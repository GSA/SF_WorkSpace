public with sharing class PBS_AAAP_OfferBuildingDetailsController extends PBS_AAAP_PageBaseController{
    public PBS_AAAP_Offer__c offerBuilding { get; set; }
    public ID offerID { get; set; }
    public ID propID { get; set; }
    public boolean isValidUser { get; set; }
    public String draftMsgFlag { get; set; }
     public String rlpType { get; set; }
    public String action { get; set; }
    public Boolean isPendingModfication { get; set; }
    public Boolean isCopy { get; set; }
    public Boolean isModify { get; set; }
    public boolean showSubmitMesg { get; set; }
    public String pageUrl{get;set;}
    public string pageURLForRedirection {get;set;}
    public String hubZoneStr { get; set; }
    public Boolean reconstructionAcknowledgement = false;
    public Boolean isHistoricProperty { get; set; }
    public Boolean isInHistoricDistrict { get; set; }
    public Boolean isNotHistoric { get; set; }
    public String selectedASL {get; set;}
    public Boolean viewOnly { get; set; }
    public String viewMsg { get; set; }
    
    
    public PBS_AAAP_OfferBuildingDetailsController(ApexPages.StandardController stdCtrl)
    {
        offerBuilding = (PBS_AAAP_Offer__c)stdCtrl.getRecord();
        
    }
    
    
    public PBS_AAAP_OfferBuildingDetailsController() {
               System.debug('Offer Building Details start');
        
        action = getQueryParamAsString('action');
        showSubmitMesg = false;
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('propertyId') != null){
            propID = ApexPages.currentPage().getParameters().get('propertyId');
        }
        String isEditable = ApexPages.currentPage().getParameters().get('edit');
        if (isEditable == 'false') {
            viewOnly = true;
            viewMsg = 'Offer opened in view mode. Any changes made will not be saved.';
        } else {
            viewOnly = false;
        }
        	
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            System.debug('Entered Offer');
            offerID = ApexPages.currentPage().getParameters().get('offerId');
            system.debug('***************offer Parking ID in Constructor:' + offerID);
            offerBuilding = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            selectedASL=offerBuilding.PBS_AAAP_Approximate_Construction_Level__c;
           
            if(offerBuilding.RecordType.Name == 'AAAP')
                    {
                        rlpType = offerBuilding.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
                    }
                    else if(offerBuilding.RecordType.Name == 'RSAP'){rlpType = offerBuilding.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                    }
            if (offerBuilding.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
                Boolean isValidOffer = PBS_AAAP_GlobalConstants.checkOfferIsValidOrNot(offerBuilding);
                if(!isValidOffer){
                    showSubmitMesg = true;
                }
                if (action == PBS_AAAP_GlobalConstants.OFFER_MODIFY) {
                    isModify = true;
                }
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            System.debug('Valid User: '+isValidUser);
            
            if (offerBuilding.PBS_AAAP_HubZone_SBC__c == 'No') {
                
                hubZoneStr = 'I am not a HUBZone small business concern offeror.';
            }
            if (offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'Yes') {
                
                hubZoneStr = 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.';
            }
            if (offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'No') {
                
                hubZoneStr = 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.';
            }
        }

    }
    
    private boolean checkOfferBuildingValidations() {
        //logMethodStart('checkOfferBuildingValidations');
        
        System.debug('IsNull(offerBuilding)='+(offerBuilding==null?'1':'0'));

        boolean flag;
    
        System.debug('***** message size checkOfferBuildingValidations: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());

        //logMethodEnd('checkOfferBuildingValidations', flag);
        return flag;
    }


    // Back button logic
    public PageReference backToOfrBlding() {
		
         PageReference p = new PageReference('Offer-RLP');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('Offer-RLP', Label.LOP_Community_Base_URL+'Offer-RLP');
        return null;
        
    }
   
    public PageReference saveBuilding() {
        return saveBuilding(false);
    }

    public PageReference saveBuilding(boolean force) {
        system.debug( 'saveBuilding force ' + force );
        logMethodStart('saveBuilding');
        boolean errorflag = checkOfferBuildingValidations();
        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag + '  *** offerBuilding.PBS_AAAP_RLP_Number__c ***' + offerBuilding.PBS_AAAP_RLP_Number__c + ' offerbuilding Id is ' + offerBuilding.id);
        if (errorflag == true && !force) {return null;
        }
        draftMsgFlag = '';
        PageReference p = null;
    
        try {

                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
            if(offerBuilding.PBS_AAAP_Reconstruction__c == 'No'){
                offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = false;
                }
            else if(offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes'){
                offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = true;
                }
               
                if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                	offerBuilding.PBS_AAAP_HubZone_SBC__c = 'No';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.') {
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = 'Yes';
                    offerBuilding.PBS_AAAP_HubZone_SBC__c = 'Yes';//uncomment it for HUBZone
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.') {
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = 'No';
                    offerBuilding.PBS_AAAP_HubZone_SBC__c = 'Yes';//uncomment it for HUBZone
                }
                if(offerBuilding.PBS_AAAP_HubZone_SBC__c == 'No'){
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
               if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
               
        if (
            offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes' &&
            offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'No'
        ) {
            
            offerBuilding.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes';
        }
        PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offerBuilding,new List<String>{'Offer-M-Eligibility'});
        if (response.errorMessages.size() > 0 ) {
            for(String error : response.errorMessages){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            return null;
        }
            
            update offerBuilding;
            offerBuilding = null; // clears ViewState for visual force page

            
            p = new PageReference('/AAAP/OfferParking');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {p.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = p.getUrl();
            
            pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Parking?edit=true&propertyId='+propId+'&offerId='+offerId;
            p.setRedirect(false);
            return null;
            
            

        } catch (Exception ex) {Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));

        }
        logMethodEnd('saveBuilding', p);
       
        return null;
     
    }

    public PageReference actionSaveBuildingInfo() {
        return actionSaveBuildingInfo(false);
    }

    public PageReference actionSaveBuildingInfo(boolean force) {
        system.debug('pageUrl ' + pageUrl);        
        system.debug( 'saveBuilding force ' + force );

        logMethodStart('actionSaveBuildingInfo');
          

        PageReference p = null;     
        
        try {

            // save the data to the property object
            
            draftMsgFlag = '';
            system.debug('draftMsgFlag : '+draftMsgFlag);
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
                
                
                if(offerBuilding.PBS_AAAP_Reconstruction__c == 'No'){
                offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = false;
                }
            else if(offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes'){
                offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = true;
                }
                if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                    offerBuilding.PBS_AAAP_HubZone_SBC__c = 'No';
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.') {
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = 'Yes';
                   // offerBuilding.PBS_AAAP_HubZone_SBC__c = null;//Comment it for HUBZone
                    offerBuilding.PBS_AAAP_HubZone_SBC__c = 'Yes';//uncomment it for HUBZone
                }
                if (hubZoneStr == 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.') {
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = 'No';
                   // offerBuilding.PBS_AAAP_HubZone_SBC__c = null;//Comment it for HUBZone
                    offerBuilding.PBS_AAAP_HubZone_SBC__c = 'Yes';//uncomment it for HUBZone
                }
                if(offerBuilding.PBS_AAAP_HubZone_SBC__c == 'No'){
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
            
                if (hubZoneStr == 'I am not a HUBZone small business concern offeror.') {
                offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
               
        if (
            offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes' &&
            offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'No'
        ) {
            offerBuilding.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes';
        }

                
                PBS_AAAP_Utility.OfferValidationResponse response  = PBS_AAAP_Utility.validateOffer(offerBuilding,new List<String>{'Offer-M-Eligibility'});
                if (response.errorMessages.size() > 0 && !test.isrunningtest()) {
                    for(String error : response.errorMessages){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                    }
                    return null;
                }
                update offerBuilding;
                String offerId = offerBuilding.Id;
                    //offerBuilding = null; // clears ViewState for visual force page

                if( !(( pageUrl == null ) || ( pageUrl == '' )) )                
                {
                    Integer len = pageUrl.length();
                    if( pageUrl.mid(len-1, 1) == '=' )
                    {
                        pageUrl = pageUrl + offerId;   
                    }                    
                    p = new PageReference(pageUrl);
                    
                    pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(p.getUrl());
                	return null;
                                             
                }
				
                    
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
		
        //added by s for Save 
        PageReference pref = new PageReference('/AAAP/OfferBuildingDetails?offerId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pref.getParameters().put('draftMsg', draftMsgFlag);
            
        pageURLForRedirection = pref.getUrl();
        
		pageURLForRedirection = Label.LOP_Community_Base_URL+'Offer-M-Eligibility?edit=true&propertyId='+propId+'&offerId='+offerId;
        return null;
        
    }

    // logic for delete button
    public PageReference actionDeleteOffer() {
        PageReference pref = null;
        System.debug('************* offerBuilding ::: ' + offerBuilding);
        System.debug('************* offerBuilding.PBS_AAAP_Offer_Status__c ::: ' + offerBuilding.PBS_AAAP_Offer_Status__c);
        System.debug('************* offerBuilding.PBS_AAAP_Offer_Status__c ::: ' + PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT);
        if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT ||
                offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_PENDINGMODIFICATION) {
            delete offerBuilding;    // Cascade delete - Deletes all Spaces and Othercosts associated with it.
           
            pref = new PageReference('/AAAP/PortalHome');
            pref.setRedirect(true);
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Offer is on ' + offerBuilding.PBS_AAAP_Offer_Status__c +
                    ', you can only delete on Draft or Pending Modification stage');
            ApexPages.addMessage(myMsg);
        }

        return pref;
    }

    public PageReference actionCancel() {
        
        PageReference pref = null;
        pageURLForRedirection = '';
		pref = new PageReference('/AAAP/PortalHome');
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PortalHome', Label.LOP_Community_Base_URL+'Offer-Home');
            
        pref.setRedirect(false);
         logMethodEnd('exitBuilding', pref);
        return null;
    }

    public List<SelectOption> getPartialItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('Partial', 'Partial'));
        return options;
    }
    
    public List<SelectOption> getFireLifeMeetsItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The property meets the lease fire protection/life safety standards.'));
        options.add(new SelectOption('Will meet', 'The property will be improved to meet the lease fire protection/life safety standards.'));
        options.add(new SelectOption('Does not meet', 'The property does not meet the lease fire protection/life safety standards and will not be upgraded.'));
        return options;
    }

    //SGanti added logic for Accessibility__c on 7/20/2021
      public List<SelectOption> getAccessibilityItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The property meets the lease accessibility standards.'));
        options.add(new SelectOption('Will meet', 'The property will be improved to meet the lease accessibility standards.'));
        options.add(new SelectOption('Does not meet', 'The property does not meet the lease accessibility standards and will not be upgraded.'));
        return options;
    }
  //SGanti added logic for Flood_Plains__c on 7/21/2021
    public List<SelectOption> getFloodPlainsItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('100', 'The property is in a base (100-year) floodplain.'));
        options.add(new SelectOption('500', 'The property is in a (500-year) floodplain.'));
        options.add(new SelectOption('None', 'The property is not in a floodplain.'));
        return options;
    }  
 
  //SGanti added logic for Asbestos__c on 7/21/2021
  
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
                if (this.offerBuilding.PBS_AAAP_Asbestos__c !=null && this.offerBuilding.PBS_AAAP_Asbestos__c.contains(objc.getValue()))
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
            offerBuilding.PBS_AAAP_Asbestos__c = selectedCheckBox;
        }
    }  
    
    public List<SelectOption> getItems() {
        logMethodStart('getItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        logMethodEnd('getItems', options);
        return options;
    }
    
    public List<SelectOption> getYesNoItems() {
        logMethodStart('getItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('Yes', ' Yes -  I acknowledge and agree that offers involving complete rehabilitation or reconstruction must meet the schedule requirements of the RLP.'));
        logMethodEnd('getItems', options);
        return options;
    }

    public Boolean showEnergyStar = false;
    
    public PageReference displayEnergyStarText() {
        logMethodStart('displayEnergyStarText');
        showEnergyStar = offerBuilding.PBS_AAAP_Energy_Star__c == 'No';     
       
        logMethodEnd('displayEnergyStarText');
        return null;
    }
 
    public boolean getShowEnergyStar() {
       logMethodStart('getShowEnergyStar');
        if (offerBuilding.PBS_AAAP_Energy_Star__c == 'No') {
            showEnergyStar = true;
            }
          
            
       logMethodEnd('getShowEnergyStar', showEnergyStar);
        return showEnergyStar;
    }
    
    public List<SelectOption> getStairwellItems() {
        logMethodStart('getItems');
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
        options.add(new SelectOption('NA', 'NA'));
        logMethodEnd('getItems', options);
        return options;
    }
    
    public Boolean buildingLocated = false;
    public boolean getBuildingLocated() {
        logMethodStart('getBuildingLocated');
        if (offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes') {
            buildingLocated = true;
        }
        logMethodEnd('getBuildingLocated', buildingLocated);
        return buildingLocated;
    }
    
    public PageReference displayBuildingTypeCodeyear() {
        logMethodStart('displayBuildingTypeCodeyear');
        buildingLocated = offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes';
        logMethodEnd('displayBuildingTypeCodeyear');
        return null;
    }

    public Boolean metroStation = false;
    public PageReference displayMetroStation() {
        logMethodStart('displayMetroStation');
        metroStation = offerBuilding.PBS_AAAP_Close_To_Metro__c == 'Yes';
        logMethodEnd('displayMetroStation');
        return null;
    }

    public boolean getMetroStation() {
        logMethodStart('getMetroStation');
        if (offerBuilding.PBS_AAAP_Close_To_Metro__c == 'Yes') {
            metroStation = true;
        }
        logMethodEnd('getMetroStation', metroStation);
        return metroStation;
    }
    
    public PageReference displayreconstructionAcknowledgement() {
        logMethodStart('displayMetroStation');
        reconstructionAcknowledgement = offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes';
        logMethodEnd('displayMetroStation');
        return null;
    }

    public boolean getreconstructionAcknowledgement() {
        logMethodStart('getMetroStation');
        if (offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes') {
            reconstructionAcknowledgement = true;
        }
        logMethodEnd('getMetroStation', metroStation);
        return reconstructionAcknowledgement;
    }
    
    public Boolean hzone = false;
    public PageReference displayhzone() {
        logMethodStart('displayMetroStation');
        hzone = offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes';
        logMethodEnd('displayMetroStation');
        return null;
    }

    public boolean gethzone() {
        logMethodStart('getMetroStation');
        if (offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes') {
            hzone = true;
        }
        logMethodEnd('getMetroStation', metroStation);
        return hzone;
    }
    
    
    
    public List<SelectOption> getSeismicSafetyItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The building either fully meets RLP seismic requirements or meets an exemption.'));
        options.add(new SelectOption('Will meet', 'The building will be retrofitted to meet RLP seismic requirements it does not currently meet.'));
        options.add(new SelectOption('Will not meet', 'The building will not meet RLP seismic requirements.'));
        
        return options;
    }
    
    public List<SelectOption> getHubZoneItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('I am not a HUBZone small business concern offeror.', 'I am not a HUBZone small business concern offeror.'));
        options.add(new SelectOption('I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.', 'I am a HUBZone small business concern offeror, and I elect to waive the price evaluation preference.'));
        options.add(new SelectOption('I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.', 'I am a HUBZone small business concern offeror, and do not waive the price evaluation preference.'));
        
        return options;
    }
    
    public PageReference aslToggleAction() {
        offerBuilding.PBS_AAAP_Approximate_Construction_Level__c = selectedASL;

        return null;
    } 

}