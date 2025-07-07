/**
 * Created by nkopparthi on 5/20/19.
 */

public with sharing class PBS_LOP_BuildingController {

    public String offerId { get; set; }
    public String propId { get; set; }
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
	
    public List<SelectOption> getSeismicSafetyItems() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = PBS_AAAP_Offer__c.PBS_AAAP_Seismic_Statement__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
        return options;
    }
    
    public PBS_LOP_BuildingController() {
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.Contact.Phone, u.Contact.Email, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        action = ApexPages.currentPage().getParameters().get('action');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        propId = ApexPages.currentPage().getParameters().get('propertyId');
        isNew = ApexPages.currentPage().getParameters().get('isNew');
        isEditable = ApexPages.currentPage().getParameters().get('edit');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');

        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
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
            system.debug('JK *****RLP' + rlp.PBS_RSAP_Solicitation_Number__c);
            if (lopOffer.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                if (lopOffer.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c) {
                    isTerminated = false;
                } else {
                    isTerminated = true;
                }
                if (isTerminated) {
                    viewOnly = true;
                    viewMsg = 'Project is terminated. Offer opened in view mode. Any changes made will not be saved.';
                    System.debug('*** isEditable ***' + isEditable);
                } 
                    else if (lopOffer.PBS_AAAP_Offer_Status__c == 'Closed') {
                    viewOnly = true;
                    viewMsg = 'Project due date has elapsed. Offer opened in view mode. Any changes made will not be saved.';
                    
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
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am not a HUBZone small business concern offeror.') {
                hubZoneStr = 'I am not a HUBZone small business concern offeror.';
            }
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.') {
                hubZoneStr = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            }
            if (lopOffer.PBS_RSAP_HubZone_Waiver__c == 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.') {
                hubZoneStr = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
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
                lopOffer.PBS_RSAP_HubZone_Waiver__c = hubZoneStr;
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
                if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
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

                


                lopOffer.PBS_AAAP_Offeror__c = userDetail.ContactId;
                lopOffer.PBS_AAAP_Offeror_Primary_Phone_Number__c = userDetail.Contact.Phone;
                lopOffer.PBS_AAAP_Offeror_Email__c = userDetail.Contact.Email;
//SGanti 10/2021                
                
                
                if (lopOffer.PBS_AAAP_Energy_Star__c == 'No') {
                    lopOffer.PBS_AAAP_CERTIFICATION_DATE__c = null;
//SGanti added 10/2021                    
                    
                    if(lopOffer.PBS_RSAP_Energy_Star_Response_No__c != 'Statutory Exception') {
                        lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c = NULL;
                        lopOffer.PBS_AAAP_Energy_Star_Evaluation__c = NULL;
                    }
                    
                } else {
//SGanti added 10/2021                    
                    
                    lopOffer.PBS_RSAP_Energy_Star_Response_No__c = NULL;
                    lopOffer.PBS_RSAP_Energy_Star_Meets_Exceptions__c = NULL;
                    lopOffer.PBS_AAAP_Energy_Star_Evaluation__c = NULL;
                }

                if (lopOffer.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c != 'Yes') {
                    lopOffer.PBS_RSAP_Offeror_Seismic_Declaration__c = '';
                }
                PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopOffer,new List<String>{'Offer-S-Eligibility'});
                if (response.errorMessages.size() > 0 ) {
                    for(String error : response.errorMessages){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                    }
                    return null;
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
                if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am not a HUBZone small business concern offeror.';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.') {
                    lopOffer.PBS_RSAP_HubZone_Waiver__c = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
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

      
        p = new PageReference('/RSAP/Building');
        p.getParameters().put('offerId', offerId);
        p.getParameters().put('draftMsg', draftMsgFlag);
              

        pageURLForRedirection = p.getUrl();
 
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-Eligibility?edit=true&offerId='+offerId+'&propertyId='+propId;
        System.debug('*****'+pageURLForRedirection);
        return null;
        // end SFWS-2105

    }
    public void back() {
        System.debug('in back method');
        String propertyId = ApexPages.currentPage().getParameters().get('propertyId');
       
        pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-RLP?edit='+(viewOnly ? 'false' : 'true')+'&offerId='+offerId+'&propertyId='+propId;
    }

    public PageReference redirectToParking() {
        lopOffer.PBS_RSAP_HubZone_Waiver__c = hubZoneStr;
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
                PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(lopOffer,new List<String>{'Offer-S-Eligibility'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
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
               
                pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-S-SpaceParking?edit=true&offerId='+offerId+'&propertyId='+propId;
                p.setRedirect(false);
            } else {
                p = new PageReference(pageURL);
                pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pageURL);
                System.debug('*****'+pageURLForRedirection);
         
                p.setRedirect(false);
               
            }
     
            
            return null;
            
    }

    public PageReference actionDeleteOffer() {

        //List<string> spaceidList;

        PageReference pref = null;
		/*
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
		*/
        return pref;

    }

//SGanti added logic for energy star response = "No" on 10/2021.
              
    public List<SelectOption> getEnergyStarResponseNo() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('New construction', 'New construction'));
        options.add(new SelectOption('Insufficient Occupancy', 'Existing building with insufficient occupancy'));
        options.add(new SelectOption('Statutory Exception', 'Meets one of the following exemptions below:'));
        return options;
    }

//SGanti added logic for energy star response = "No" ,"Statutory Exception" on 10/2021.               

    public List<SelectOption> getEnergyStarMeetsExceptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Agency Staying', 'The agency will remain in the building it currently occupies.'));
        options.add(new SelectOption('Special Category', 'The property is of historical, architectural, or cultural significance listed or eligible to be listed on the National Register of Historic Places.'));
        options.add(new SelectOption('10k or less', 'The lease will be 10,000 RSF or less.'));
        return options;
    }    
               

    public List<SelectOption> getEnergyStarCost() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Improvements declared', 'Cost effective improvements have been identified and are attached to this offer.'));
        options.add(new SelectOption('no effective improvements', 'There are no cost effective improvements. Supporting evidence is attached to this offer.'));
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
            lopOffer.PBS_AAAP_Asbestos__c = selectedCheckBox == '' ? Null:selectedCheckBox;
        }
    }  

//SGanti added logic for accessibility items 10/2021.
 
    public List<SelectOption> getAccessibilityItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The property meets the lease accessibility standards.'));
        options.add(new SelectOption('Will meet', 'The property will be improved to meet the lease accessibility standards.'));
        options.add(new SelectOption('Does not meet', 'The property does not meet the lease accessibility standards and will not be upgraded.'));
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
        options.add(new SelectOption('The RLP does not contain seismic requirements.', 'The RLP does not contain seismic requirements.'));
        options.add(new SelectOption('The building either fully meets RLP seismic requirements or meets an exemption.', 'The building either fully meets RLP seismic requirements or meets an exemption.'));
        options.add(new SelectOption('The building will be retrofitted to meet RLP seismic requirements it does not currently meet.', 'The building will be retrofitted to meet RLP seismic requirements it does not currently meet.'));
        options.add(new SelectOption('The building will be constructed to meet RLP seismic requirements.', 'The building will be constructed to meet RLP seismic requirements.'));
        options.add(new SelectOption('The building will not meet RLP seismic requirements.', 'The building will not meet RLP seismic requirements.'));
        return options;
    }
    
//SGanti reworded options on 10/2021.        
    
    public List<SelectOption> getFloodPlainItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('in a base (100-year) flood plain', 'The property is in a base (100-year) floodplain.'));
        options.add(new SelectOption('in a 500-year flood plain', 'The property is in a (500-year) floodplain.'));
        options.add(new SelectOption('Not in a flood plain', 'The property is not in a floodplain.'));
        return options;
    }

//SGanti added options on 10/2021.                     
    public List<SelectOption> getFireProtectionItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The property meets the lease fire protection/life safety standards.'));
        options.add(new SelectOption('Will meet', 'The property will be improved to meet the lease fire protection/life safety standards.'));
        options.add(new SelectOption('Does not meet', 'The property does not meet the lease fire protection/life safety standards and will not be upgraded.'));
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
        options.add(new SelectOption('I am not a HUBZone small business concern offeror.', 'I am not a HUBZone small business concern offeror.'));
        options.add(new SelectOption('I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.', 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.'));
        options.add(new SelectOption('I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.', 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.'));
        return options;
    }
    /*
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
    */
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