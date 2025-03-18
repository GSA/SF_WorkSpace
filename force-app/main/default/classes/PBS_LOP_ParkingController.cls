/**
 * Created by nkopparthi on 5/20/19.
 */

public with sharing class PBS_LOP_ParkingController {

    public boolean isValidUser { get; set; }
    public String offerId { get; set; }
    public String isNew { get; set; }
    public String action { get; set; }
    public string isEditable { get; set; }
    public User userDetail { get; set; }
    public String draftMsgFlag { get; set; }
    public Boolean viewOnly { get; set; }
    public string viewMsg { get; set; }
    public PBS_AAAP_Offer__c lopOffer { get; set; }
    public PBS_AAAP_RLP__c rlp {get; set;}
    public Boolean isTerminated { get; set; }
    public String pageURL {get; set;}
    public PBS_AAAP_QuestionLabels qLabels { get; set; }
    public String pageURLForRedirection{get;set;}    // j.rogers 1/18/2023  SFWS-2107

    public PBS_LOP_ParkingController() {

        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        qLabels = new PBS_AAAP_QuestionLabels();

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in a View mode';
        } else {
            viewOnly = false;
        }

        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            lopOffer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);

            // jrogers testing
            system.debug('PBS_AAAP_Parking_Onsite__c ===> '+ lopOffer.PBS_AAAP_Parking_Onsite__c);
            
            String rlpId = lopOffer.PBS_AAAP_RLP_Number__c;
            rlp = [
                    SELECT PBS_RSAP_Solicitation_G_REX_ID__c,PBS_RSAP_Solicitation_Number__c,PBS_RSAP_Solicitation_Status__c,PBS_RSAP_State__c,PBS_RSAP_Broker__c, PBS_RSAP_Lease_Contracting_Officer__c, PBS_RSAP_Leasing_Specialist__c,  //JK 2.9.21 added 3 new GREX contact email fields on RLP here
                            PBS_RSAP_Project_Number__c,PBS_RSAP_City__c
                    FROM PBS_AAAP_RLP__c
                    WHERE Id = :rlpId
                    LIMIT 1
            ];

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
                    viewOnly = true;
                    viewMsg = 'Project due date has elapsed. Offer opened in a view mode';
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
        } else {
            isValidUser = true;
            lopOffer = new PBS_AAAP_Offer__c();
        }
   
        
    }

    public PageReference backToOfrBlding() {

        system.debug('***** started backToOfrBlding ******');
        PageReference p = new PageReference('/RSAP/Building');
        //PageReference p = Page.PBS_LOP_Building;
        p.getParameters().put('offerId', offerId);
        if (isEditable == 'true') {
            p.getParameters().put('edit', 'true');
        } else {
            isEditable = 'false';
        }

        /* SFWS-2107  01/18/2023 j.rogers */
          //  p.setRedirect(true);
          // return p;
       

        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/Building', Label.LOP_Community_Base_URL+'RSAP-Building');

        
        system.debug('***** finished backToOfrBlding ******');
        return null;
        /* end 2107 */


    }

    public PageReference saveParkingInfo() {
        PageReference p = null;

        Boolean flag = false;
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

        /*if (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c <= lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.LOP_SPACE_RATES_RSF_GT_ABOA));
            flag = true;
        }*/

        /* Todd Brown 10/08/2021 commented out edits for removed parking fields and added edits for new fields for SFWS-1400
        if (lopOffer.PBS_AAAP_Total_Surface_Parking_Spaces__c < lopOffer.PBS_RSAP_Emp_Visitor_Surface_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Employee/Visitor Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_GOV_Surface_Spaces__c > lopOffer.PBS_AAAP_Total_Surface_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Official Government Vehicles Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_Emp_Visitor_Structured_Spaces__c > lopOffer.PBS_AAAP_Total_Structured_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Employee/Visitor Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_GOV_Structured_Spaces__c > lopOffer.PBS_AAAP_Total_Structured_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Official Government Vehicles Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c == null || lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '5.  Annual Cost Per Space Surface / Structured are required fields.  Please put 0.00 if there is no separate charge for parking.'));
            flag = true;
        }
        */
        if (lopOffer.PBS_AAAP_Parking_Onsite__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. Onsite parking response is required.'));
            flag = true;
        } 
        if (lopOffer.PBS_AAAP_Monthly_cost_res_gar_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_nonres_gar_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_res_sur_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_nonres_sur_park__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    '4. Please enter rates for all types of parking. Please put $0.00 if you are either not charging for, or not offering, that type of parking space. You may not leave any fields blank.'));
            flag = true;
         }
         //added by Ramya 07/2022
          if (lopOffer.PBS_RSAP_Surf_Resv_Parking__c  == null ||
            lopOffer.PBS_RSAP_Surf_NonResv_Parking__c == null ||
            lopOffer.PBS_RSAP_Struct_Resv_Parking__c == null ||
            lopOffer.PBS_RSAP_Struct_NonResv_Parking__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    '5. Please enter number of parking spaces offered to satisfy the parking requirements of the RLP. You may not leave any fields blank.'));
            flag = true;  
        }
        if (flag == true) {
            return null;
        }
        try {
            lopOffer.PBS_AAAP_Common_Area_Factor__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (100 * (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c - lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c).setScale(2) : 0.00;
            draftMsgFlag = '';
            //updateAreaType(lopOffer);
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            //SFWS-847
            lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : 0;
            lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c) : 0;
            //SFWS-847
            update lopOffer;
        } catch (Exception ex) {
            Apexpages.addMessages(ex);
        }

        p = new PageReference('/RSAP/SpacesAndParking');
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);

        // SFWS 2107 - j. rogers 1/18/2023
            //p.setRedirect(true);
            //return p;      
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/RSAP/SpacesAndParking', Label.LOP_Community_Base_URL+'RSAP-SpacesAndParking');
        
        return null;
    }

    public PageReference saveParkingAndContinue() {

        //system.debug('***************offer Parking ID :'+offerParking);
        PageReference p = null;

        Boolean flag = false;
        
        //Parking
      
        /*Todd Brown 10/08/2021 commented out edits for removed parking fields and added edits for new fields for SFWS-1400
        if (lopOffer.PBS_AAAP_Total_Surface_Parking_Spaces__c < lopOffer.PBS_RSAP_Emp_Visitor_Surface_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Employee/Visitor Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_GOV_Surface_Spaces__c > lopOffer.PBS_AAAP_Total_Surface_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Official Government Vehicles Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_Emp_Visitor_Structured_Spaces__c > lopOffer.PBS_AAAP_Total_Structured_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '3. Employee/Visitor Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_GOV_Structured_Spaces__c > lopOffer.PBS_AAAP_Total_Structured_Parking_Spaces__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '4. Official Government Vehicles Parking cannot exceed total building parking.'));
            flag = true;
        }
        if (lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c == null || lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '5.  Annual Cost Per Space Surface / Structured are required fields.  Please put 0.00 if there is no separate charge for parking.'));
            flag = true;
        }*/
                    
            
        if (lopOffer.PBS_AAAP_Parking_Onsite__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '2. Onsite parking response is required.'));
            flag = true;
        } 
        //added by Ramya 07/2022
         if (lopOffer.PBS_AAAP_Monthly_cost_res_gar_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_nonres_gar_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_res_sur_park__c == null ||
            lopOffer.PBS_AAAP_Monthly_cost_nonres_sur_park__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    '4. Please enter rates for all types of parking. Please put $0.00 if you are either not charging for, or not offering, that type of parking space. You may not leave any fields blank.'));
            flag = true;
         }
          if (lopOffer.PBS_RSAP_Surf_Resv_Parking__c  == null ||
            lopOffer.PBS_RSAP_Surf_NonResv_Parking__c == null ||
            lopOffer.PBS_RSAP_Struct_Resv_Parking__c == null ||
            lopOffer.PBS_RSAP_Struct_NonResv_Parking__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,
                    '5. Please enter number of parking spaces offered to satisfy the parking requirements of the RLP. You may not leave any fields blank.'));
            flag = true;  
        }
              
        if (flag == true) {
            return null;
        }

        try {
        
              lopOffer.PBS_RSAP_Total_Parking_Annual_Amount__c = (((lopOffer.PBS_AAAP_Monthly_cost_res_gar_park__c*lopOffer.PBS_RSAP_Struct_Resv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_res_sur_park__c*lopOffer.PBS_RSAP_Surf_Resv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_nonres_gar_park__c*lopOffer.PBS_RSAP_Struct_NonResv_Parking__c)
                                                                 +(lopOffer.PBS_AAAP_Monthly_cost_nonres_sur_park__c*lopOffer.PBS_RSAP_Surf_NonResv_Parking__c))*12).setScale(2);
            draftMsgFlag = '';
            if (lopOffer.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                PBS_AAAP_GlobalConstants.updateOfferToDraft(lopOffer);
                draftMsgFlag = 'true';
            }
            //updateAreaType(lopOffer);
            //SFWS-847
            lopOffer.PBS_AAAP_OP_COST_COST_PER_ABOA__c = (lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c > 0) ? (lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c) : 0;
            lopOffer.PBS_AAAP_OP_COST_COST_PER_RSF__c = (lopOffer.PBS_AAAP_Office_RSF_OFFERED__c > 0) ? (lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c / lopOffer.PBS_AAAP_Office_RSF_OFFERED__c) : 0;
            //SFWS-847
            update lopOffer;
            String offerId = lopOffer.Id;
            lopOffer = null; // clears ViewState for visual force page

            p = new PageReference('/RSAP/OperatingCost');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            if (isEditable == 'true') {
                p.getParameters().put('edit', 'true');
            } else {
                isEditable = 'false';
            }
            // j.rogers 12/22/2022 SFWS-2107
                // p.setRedirect(true);
            // 
            if(pageURL == NULL || pageURL == ''){
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/RSAP/OperatingCost', Label.LOP_Community_Base_URL+'RSAP-OperatingCost');
            p.setRedirect(false);
                } else {
                 p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pageURL);
                 p.setRedirect(false);   
                //return pr;
            }
        
            return null;
            // end 2107
            
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            Apexpages.addMessage(myMsg);
        }
  
            if(pageURL == NULL || pageURL == ''){
                return p;
            } else {
                p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                return null;
            }
                
    }

    public PageReference actionCancel() {
        PageReference pref = new PageReference('/RSAP/PortalHome');
        //PageReference pref = Page.PBS_LOP_PortalHome;
        pref.setRedirect(true);
        return pref;
    }
    
    public void saveData() {        
        update lopOffer;
    }

    @TestVisible private void updateAreaType(PBS_AAAP_OFFER__C lopOffer) {
        //added by syam for FY16 changes
        String areaType = lopOffer.PBS_AAAP_SITE_AREA_TYPE__c;
        System.debug('*** areaType is ' + areaType);
        Decimal siteSize = lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c;
        //siteSize.setScale(2, RoundingMode.HALF_UP);
        System.debug('*** siteSize is ' + siteSize);
        if (lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c != null && areaType == 'Acres') {
            siteSize = siteSize * 43560;
            System.debug('*** siteSize inside is ' + siteSize);
            lopOffer.PBS_AAAP_SITE_SIZE_SQFT__c = siteSize;
        }

    }
    
    public List<SelectOption> getOnsiteParkingItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = PBS_AAAP_Offer__c.PBS_AAAP_Parking_Onsite__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        } 
        return options;
    }

}