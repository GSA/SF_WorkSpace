public with sharing class PBS_AAAP_OfferBuildingDetailsController extends PBS_AAAP_PageBaseController{
    public PBS_AAAP_Offer__c offerBuilding { get; set; }
    public ID offerID { get; set; }
    public boolean isValidUser { get; set; }
    public String draftMsgFlag { get; set; }
    public String pageUrl{get;set;}
    public string pageURLForRedirection {get;set;}
    public Boolean reconstructionAcknowledgement = false;
    //SGanti commented out 7/21/2021
    //public String selectedEnergyStar {get; set;}
    //SGanti commented out 7/21/2021
    
    public PBS_AAAP_OfferBuildingDetailsController(ApexPages.StandardController stdCtrl)
    {
        offerBuilding = (PBS_AAAP_Offer__c)stdCtrl.getRecord();
        
    }
    
    
    public PBS_AAAP_OfferBuildingDetailsController() {
               System.debug('Offer Building Details start');

        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            System.debug('Entered Offer');
            offerID = ApexPages.currentPage().getParameters().get('offerId');
            system.debug('***************offer Parking ID in Constructor:' + offerID);
            offerBuilding = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
            if (offerBuilding.OwnerId == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                        PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
            }
            System.debug('Valid User: '+isValidUser);
        }

    }
    
    private boolean checkOfferBuildingValidations() {
        //logMethodStart('checkOfferBuildingValidations');
        
        System.debug('IsNull(offerBuilding)='+(offerBuilding==null?'1':'0'));

        boolean flag;
    //SGanti commented out error messages 8/2/2021       
    /*  if (offerBuilding.PBS_AAAP_Building_Sprinklered__c == null) {
            //JK here need error handling for null value
            offerBuilding.PBS_AAAP_Building_Sprinklered__c = '';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_SPRINKLED_REQUIRED));
            //flag = true;
        }
        if (offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c == 'No' || offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c == null) {
            offerBuilding.PBS_AAAP_BLDG_Physical_Remote_Stairwell__c = '';
            //JK removed this because the field was deleted from the external page 7/2021
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_STAIRWELL_REQUIRED));
            //flag = true;
        }
        if (offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c == null) {
            //JK here need error handling for null value
            offerBuilding.PBS_AAAP_BLDG_Wide_Alarm_System__c = '';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ALARM_REQUIRED));
            //flag = true;
        }
    */
        
    //SGanti added 8/2021
        if (offerBuilding.PBS_AAAP_Fire_Life_Meets__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_FIRE_LIFE_MEETS));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Accessibility__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ACCESSIBILITY));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Asbestos__c == '' || offerBuilding.PBS_AAAP_Asbestos__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ASBESTOS));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Flood_Plains__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_FLOOD_PLAINS));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Close_To_Metro__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_METRO));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Energy_Star__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ENERGY_STAR_REQUIRED));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Energy_Star__c == 'No') {
            String reason = offerBuilding.PBS_AAAP_Energy_Star_Reason__c;
            if (reason.length() <= 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ENERGY_STAR_NO_REQUIRED));
                flag = true;
            }
        }
        if (offerBuilding.PBS_AAAP_Energy_Star__c == 'Yes') {
            Date certificationDate = offerBuilding.PBS_AAAP_CERTIFICATION_DATE__c;
            if (certificationDate == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_ENERGY_STAR_DATE_OF_CERTIFICATION_REQUIRED));
                flag = true;
            }
        }
        if (offerBuilding.PBS_AAAP_HIST_PROP_IN_HIST_DIST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HPHD));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_NON_HIST_PROP_IN_HIST_DIST__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_NHP_WITHIN_HD));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HubZone_SBC__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HUBZONE_SBC_STATUS));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes') {
            if(offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_HUBZONE_SBC_PREFERENCE));
                flag = true;
            }
        }
        if (offerBuilding.PBS_AAAP_Reconstruction__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_REHABILITATION));
            flag = true;
        }
        if (offerBuilding.PBS_AAAP_Reconstruction__c == 'Yes') {
            if(offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_REHABILITATION_ACKNOWLEDGEMENT));
                flag = true;
            }
        }
        
        if (offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == null) {
            system.debug('SEISMIC_ZONE_BUILDING_TYPE : '+offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.BUILDING_SEISMIC_ZONE));
            flag = true;
        }
        if ((offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes')&&(offerBuilding.PBS_AAAP_SEISMIC_STATEMENT__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.SEISMIC_SAFETY_REQUIRED));
            flag = true;
        }
        if ((offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'Yes')&&(offerBuilding.PBS_AAAP_BUILDING_TYPE__c == null || offerBuilding.PBS_AAAP_BUILDING_CODE__c == null || offerBuilding.PBS_AAAP_BUILDING_CODE_YEAR__c == null)){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, PBS_AAAP_GlobalConstants.SEISMIC_ZONE_BUILDING_TYPE));
            flag = true;
        }

        System.debug('***** message size checkOfferBuildingValidations: ' + String.valueOf(ApexPages.getMessages().size()) + ' -- ' + ApexPages.getMessages());

        //logMethodEnd('checkOfferBuildingValidations', flag);
        return flag;
    }


    // Back button logic
    public PageReference backToOfrBlding() {
		// old changes is below blocked code
        //PageReference p = Page.PBS_AAAP_OfferBuilding;
        /*PageReference p = new PageReference('/AAAP_OfferBuilding');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(true);
        return p;*/
        /*
        PageReference pref = null;
        pageURLForRedirection = '';
		pref = new PageReference('/AAAP/OfferBuilding');
        pref.getParameters().put('offerId', offerId);
        //pref.getParameters().put('draftMsg', draftMsgFlag);
        //pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pref.getUrl());
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuilding', Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
            
        pref.setRedirect(false);
         logMethodEnd('saveBuilding', pref);
        return null;  */
        //new changes start
        PageReference p = new PageReference('/AAAP/OfferBuilding');
        p.getParameters().put('offerId', offerId);
        p.setRedirect(false);
        
        pageURLForRedirection = p.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuilding', Label.LOP_Community_Base_URL+'AAAP-OfferBuilding');
        return null;
        //new changes finish
    }

    public PageReference saveBuilding() {
        return saveBuilding(false);
    }

    public PageReference saveBuilding(boolean force) {
        system.debug( 'saveBuilding force ' + force );
        logMethodStart('saveBuilding');
        boolean errorflag = checkOfferBuildingValidations();
        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag + '  *** offerBuilding.PBS_AAAP_RLP_Number__c ***' + offerBuilding.PBS_AAAP_RLP_Number__c + ' offerbuilding Id is ' + offerBuilding.id);
        if (errorflag == true && !force) {
            return null;
        }
        draftMsgFlag = '';
        PageReference p = null;
    
        try {

                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
                if (offerBuilding.PBS_AAAP_Energy_Star__c == 'No') {
                    offerBuilding.PBS_AAAP_CERTIFICATION_DATE__c = null;
                } else {
                    offerBuilding.PBS_AAAP_Energy_Star_Reason__c = '';
                }
                if(offerBuilding.PBS_AAAP_HubZone_SBC__c == 'No'){
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
                //if(offerBuilding.PBS_AAAP_Reconstruction__c == 'No'){
                //    offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = null;
                //}
                if (offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'No') {
                    offerBuilding.PBS_AAAP_SEISMIC_STATEMENT__c = null;
                    offerBuilding.PBS_AAAP_BUILDING_TYPE__c = null;
                    offerBuilding.PBS_AAAP_BUILDING_CODE__c = null;
                    offerBuilding.PBS_AAAP_BUILDING_CODE_YEAR__c = null;
                }
        if (
            offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes' &&
            offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'No'
        ) {
            offerBuilding.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes';
        }
               
            update offerBuilding;
            offerBuilding = null; // clears ViewState for visual force page

            //p = Page.PBS_AAAP_OfferParking;
            //old changes blocked below code
            /*p = new PageReference('/AAAP/OfferParking');
            p.getParameters().put('offerId', offerId);

            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            //p.setRedirect(true);
			pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferParking', Label.LOP_Community_Base_URL+'aaap-offer-parking');
			*/
            /*new changes start
            pageURLForRedirection = '';
            p = new PageReference('/AAAP/OfferParking');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            //pageURLForRedirection = Label.LOP_Community_Base_URL+PBS_AAAP_Utility.getCommunityURL(pref.getUrl());
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferParking', Label.LOP_Community_Base_URL+'AAAP-OfferParking');
             new changes finish */
            
            
              p = new PageReference('/AAAP/OfferParking');
            p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferParking', Label.LOP_Community_Base_URL+'AAAP-OfferParking');
            p.setRedirect(false);
            return null;
            
            

        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));

        }
        logMethodEnd('saveBuilding', p);
        //p.setRedirect(false);
        return null;
        //return p;
    }

    public PageReference actionSaveBuildingInfo() {
        return actionSaveBuildingInfo(false);
    }

    public PageReference actionSaveBuildingInfo(boolean force) {
        system.debug('pageUrl ' + pageUrl);        
        system.debug( 'saveBuilding force ' + force );

        logMethodStart('actionSaveBuildingInfo');

        /* BH

        boolean errorflag = checkOfferBuildingValidations();

        System.debug('=======>>>>>>>>> error flag for checkOfferBuildingValidations **** ::: ' + errorflag);
        if (errorflag == true && !force) {
            return null;
        }
        */

        PageReference p = null;     
        
        try {

            // save the data to the property object
            
            draftMsgFlag = '';
            system.debug('draftMsgFlag : '+draftMsgFlag);
                if (offerBuilding.PBS_AAAP_Offer_Status__c == PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED) {
                    offerBuilding.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_DRAFT;
                    draftMsgFlag = 'true';
                }
                
                if (offerBuilding.PBS_AAAP_Energy_Star__c == 'No') {
                    offerBuilding.PBS_AAAP_CERTIFICATION_DATE__c = null;
                } else {
                    offerBuilding.PBS_AAAP_Energy_Star_Reason__c = '';
                }
                if(offerBuilding.PBS_AAAP_HubZone_SBC__c == 'No'){
                    offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c = null;
                }
                //if(offerBuilding.PBS_AAAP_Reconstruction__c == 'No'){
                //    offerBuilding.PBS_AAAP_Reconstruction_Acknowledgement__c = null;
                //}
                if (offerBuilding.PBS_AAAP_BUILDING_LOCATED_SEISMIC_ZON__c == 'No') {
                    offerBuilding.PBS_AAAP_BUILDING_TYPE__c = null;
                    offerBuilding.PBS_AAAP_BUILDING_CODE__c = null;
                    offerBuilding.PBS_AAAP_BUILDING_CODE_YEAR__c = null;
                }
        if (
            offerBuilding.PBS_AAAP_HubZone_SBC__c == 'Yes' &&
            offerBuilding.PBS_AAAP_HubZone_SBC_Preference__c == 'No'
        ) {
            offerBuilding.PBS_AAAP_HUBZONE_IDENTIFIER__c = 'Yes';
        }

                //try {
                   // System.debug('offerBuilding.certificationDate : '+offerBuilding.PBS_AAAP_CERTIFICATION_DATE__c);
                
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
                    
                    
                    //p = new PageReference('/AAAP/OfferBuildingDetails?offerId='+offerId);
                    //return p;
                }
				/* new changes start
            p = new PageReference('/AAAP/OfferBuildingDetails');
                p.getParameters().put('offerId', offerId);
            if (draftMsgFlag == 'true') {
                p.getParameters().put('draftMsgFlag', 'true');
            }
			pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuildingDetails', Label.LOP_Community_Base_URL+'AAAP-OfferBuildingDetails');
             new changes finish*/
            
            

            
            
        } catch (Exception ex) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
		/*logMethodEnd('saveBuilding', p);
            p.setRedirect(false);
            return null;*/
        //added by s for Save 
        PageReference pref = new PageReference('/AAAP/OfferBuildingDetails?offerId='+offerId);
        pref.getParameters().put('offerId', offerId);
        pref.getParameters().put('draftMsg', draftMsgFlag);
            
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/OfferBuildingDetails', Label.LOP_Community_Base_URL+'AAAP-OfferBuildingDetails');
		return null;
        //old changes is below blocked code
		/*String offerId = offerBuilding.Id;
        //if (errorflag) {
         //   p = null;
        //} else {
            offerBuilding = null; // clears ViewState for visual force page
            //p = Page.PBS_AAAP_OfferBuildingDetails;
            //p = new PageReference(Label.LOP_Community_Base_URL+'aaap-building-details');//'/AAAP/OfferBuildingDetails'
        	p = new PageReference(Label.LOP_Community_Base_URL+'AAAP_OfferBuildingDetails');
            p.getParameters().put('offerId', offerId);
            p.getParameters().put('draftMsg', draftMsgFlag);
            pageURLForRedirection = p.getUrl();

            //p.setRedirect(true);
            
        //}
        logMethodEnd('actionSaveBuildingInfo', p);*/
        //return p;

        
        //return null;
        //PageReference pref = new PageReference('/AAAP/OfferBuildingDetails?offerId='+offerId);
        //return pref;
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
            //pref = Page.PBS_AAAP_PortalHome;
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
        //PageReference pref = Page.PBS_AAAP_PortalHome;
        /*PageReference pref = new PageReference('/AAAP/PortalHome');
        pref.setRedirect(true);
        return pref;*/
        PageReference pref = null;
        pageURLForRedirection = '';
		pref = new PageReference('/AAAP/PortalHome');
        pageURLForRedirection = pref.getUrl();
        pageURLForRedirection = pageURLForRedirection.replace('/AAAP/PortalHome', Label.LOP_Community_Base_URL+'AAAP-PortalHome');
            
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
        options.add(new SelectOption('Meets', 'The Property meets the Lease fire protection/life safety standards.'));
        options.add(new SelectOption('Will meet', 'The Property will be improved to meet the Lease fire protection/life safety standards.'));
        options.add(new SelectOption('Does not meet', 'The Property does not meet the Lease fire protection/life safety standards and will not be upgraded.'));
        return options;
    }

    //SGanti added logic for Accessibility__c on 7/20/2021
      public List<SelectOption> getAccessibilityItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Meets', 'The Property meets the Lease accessibility standards.'));
        options.add(new SelectOption('Will meet', 'The Property will be improved to meet the Lease accessibility standards.'));
        options.add(new SelectOption('Does not meet', 'The Property does not meet the Lease accessibility standards and will not be upgraded.'));
        return options;
    }
  //SGanti added logic for Flood_Plains__c on 7/21/2021
    public List<SelectOption> getFloodPlainsItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('100', 'The Property is in a base (100-year) floodplain.'));
        options.add(new SelectOption('500', 'The Property is in a (500-year) floodplain.'));
        options.add(new SelectOption('None', 'The Property is not in a floodplain.'));
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
        Schema.DescribeFieldResult fieldResult = PBS_AAAP_Offer__c.PBS_AAAP_Seismic_Statement__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        } 
        return options;
    }

}