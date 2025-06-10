public with sharing class PBS_Leasing_PropertyController {
    @AuraEnabled
    public static ResponseWrapper copyUserDetails(PBS_Leasing_OfferPropertyWrapper.objectWrapper myRecord){
        User userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode, u.Country FROM User u WHERE u.Id = :UserInfo.getUserId() limit 1];
        myRecord.PBS_AAAP_Owner_Name = userDetail.FirstName + ' ' + userDetail.LastName;
        myRecord.PBS_AAAP_SIGNATURE_LAST_NAME = userDetail.LastName;
        myRecord.PBS_AAAP_Signature_First_Name = userDetail.FirstName;
        myRecord.PBS_AAAP_Owner_Address = userDetail.Street;
        myRecord.PBS_AAAP_Owner_City = userDetail.City;
        myRecord.PBS_AAAP_Owner_State = userDetail.State;
        myRecord.PBS_AAAP_Owner_Zip = userDetail.postalCode;
        myRecord.PBS_AAAP_Owner_Country = userDetail.Country;
        myRecord.PBS_RSAP_Property_Owner_Same_as_Offeror = TRUE;
        myRecord.PBS_AAAP_OFFEROR_INTEREST = 'Owner';
        myRecord.PBS_AAAP_OFFEROR_INTEREST_OTHER = Null;
        ResponseWrapper responseObj = new ResponseWrapper();
        try{
            PBS_Leasing_OfferPropertyWrapper.saveUserDetails(myRecord);
            responseObj.isSuccess = true;
        }catch(Exception e){
            responseObj.addErrorMessage(e.getMessage());
        }
        return responseObj;
    }        
    
    @AuraEnabled
    public static ResponseWrapper saveProperty(PBS_AAAP_Property__c propertyRecord,String pageName){
        
        System.debug('propertyRecord: ' + propertyRecord);
        String propStateAbbr = '';
        
        if(propertyRecord.PBS_AAAP_State__c!= null)
        {
            propStateAbbr = getAbbreviation(propertyRecord.PBS_AAAP_State__c);
        }

        ResponseWrapper responseObj = new ResponseWrapper();
        responseObj = validateProperty(propertyRecord,new List<String>{pageName});
        if(responseObj.errorMessages.size() == 0){
            try{
                if(propStateAbbr != null)
                {
                 propertyRecord.PBS_AAAP_State__c = propStateAbbr;   
                }
                update propertyRecord;
                responseObj.isSuccess = true;
            }catch(DMLException e){
                responseObj.addErrorMessage(e.getDmlMessage(0));
            }
        }
        responseObj.propId = propertyRecord.Id;
        return responseObj;
    }
    @AuraEnabled
    public static Id addnewProperty(String propName,String propAddr)
    {
        PBS_AAAP_Property__c prop=new PBS_AAAP_Property__c();
        prop.PBS_AAAP_Building_Name__c=propName;
        prop.PBS_AAAP_Street_Address__c=propAddr;
        try{
            insert prop;
        }
        
        catch(Exception e)
        {
            System.debug('Error'+e);
        }
        
        return prop.Id;
        
    }
    @AuraEnabled
    public static PBS_Leasing_OfferPropertyWrapper.objectWrapper getPropertyOfferDetails(String recordId) { 
       return PBS_Leasing_OfferPropertyWrapper.getPropertyDetails(recordId);
    }
    //Added by Ramya
    @AuraEnabled
    Public static ResultWrapper getPropertyInfo(){
        List<PBS_AAAP_Property__c> propList = [SELECT ID,PBS_AAAP_Building_Name__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_State__c 
                                                                                            FROM PBS_AAAP_Property__c 
                                                                                            WHERE OwnerID = :userInfo.getUserId()];
        ResultWrapper resWrap = new ResultWrapper();
        resWrap.propList = propList;
        system.debug(' @@@ '+resWrap.propList);
        return resWrap;
    }

    @AuraEnabled
    public static ResponseWrapper createPropertyRecord(PBS_AAAP_Property__c propertyRecord,String pageName) {
        ResponseWrapper resultOfCreateProp = new ResponseWrapper();
        resultOfCreateProp = validateProperty(propertyRecord,new List<String>{pageName});      
        if(resultOfCreateProp.errorMessages.size() == 0){
            try{
        insert propertyRecord;
        resultOfCreateProp.isSuccess = true;
            }
            catch(DMLException e){
                resultOfCreateProp.addErrorMessage(e.getDmlMessage(0));
            }
        }
        resultOfCreateProp.propId = propertyRecord.Id;
        return resultOfCreateProp; // Return the ID of the newly created property
    }
    
    @AuraEnabled
    public static ResponseWrapper updateOfferRecord(PBS_AAAP_Offer__c offerRecord,String pageName) {
        String offerStateAbbr = '';
        
        if(offerRecord.PBS_AAAP_State__c!= null)
        {
            offerStateAbbr = getAbbreviation(offerRecord.PBS_AAAP_State__c);
        }
        ResponseWrapper resultOfUpdateOffer = new ResponseWrapper();
        resultOfUpdateOffer = validateOffer(offerRecord,pageName);
        if(resultOfUpdateOffer.errorMessages.size() == 0){
            try{
            PBS_AAAP_Offer__c existOffer = [SELECT Id,property__c,recordtype.name FROM PBS_AAAP_OFFER__C WHERE Id = :offerRecord.Id limit 1];
           if(existOffer.property__c == null)
           {
                PBS_AAAP_Property__c newProperty = new PBS_AAAP_Property__c();
               
                newProperty.PBS_AAAP_Building_Name__c = offerRecord.PBS_AAAP_Building_Name__c;
                newProperty.PBS_AAAP_Street_Address__c= offerRecord.PBS_AAAP_Street_Address__c;
                newProperty.PBS_AAAP_City__c = offerRecord.PBS_AAAP_City__c;
                if(offerStateAbbr != null)
                {
                 newProperty.PBS_AAAP_State__c = offerStateAbbr;   
                }
               else{
                newProperty.PBS_AAAP_State__c = offerRecord.PBS_AAAP_State__c;
               }
                newProperty.PBS_AAAP_County__c = offerRecord.PBS_AAAP_County__c;
                newProperty.PBS_AAAP_X_CO_ORD__c = offerRecord.PBS_AAAP_X_CO_ORD__c;
                newProperty.PBS_AAAP_Y_CO_ORD__c = offerRecord.PBS_AAAP_Y_CO_ORD__c;
                newProperty.PBS_AAAP_ZipCode__c = offerRecord.PBS_AAAP_ZipCode__c;
                newProperty.PBS_AAAP_floors_Suites_in_Offered_Space__c = offerRecord.PBS_AAAP_floors_Suites_in_Offered_Space__c;
                newProperty.PBS_AAAP_OFFICE_SPACE_RSF__c = offerRecord.PBS_AAAP_OFFICE_SPACE_RSF__c;
                newProperty.PBS_AAAP_RETAIL_SPACE_RSF__c = offerRecord.PBS_AAAP_RETAIL_SPACE_RSF__c;
                newProperty.PBS_AAAP_GARAGE_SPACE_RSF__c = offerRecord.PBS_AAAP_GARAGE_SPACE_RSF__c;
                newProperty.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = offerRecord.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
                newProperty.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = offerRecord.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                newProperty.PBS_AAAP_Common_Area_Factor__c = offerRecord.PBS_AAAP_Building_Common_Area_Factor__c;
                newProperty.PBS_AAAP_Total_Surface_Parking_Spaces__c = offerRecord.PBS_AAAP_Total_Surface_Parking_Spaces__c;
                newProperty.PBS_AAAP_Total_Structured_Parking_Spaces__c = offerRecord.PBS_AAAP_Total_Structured_Parking_Spaces__c;
                newProperty.PBS_AAAP_Total_Park_Spaces_Offered__c = offerRecord.PBS_AAAP_Total_Park_Spaces_Offered__c;
                newProperty.PBS_AAAP_User_Defined_Address__c = offerRecord.PBS_AAAP_User_Defined_Address__c;
                newProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = offerRecord.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
                newProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = offerRecord.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
                newProperty.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
                newProperty.PBS_AAAP_HVAC_HRS_ON_SAT_END__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
                newProperty.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
                newProperty.PBS_AAAP_HVAC_HRS_ON_SUN_END__c =offerRecord.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;
                newProperty.PBS_AAAP_Owner_Name__c = offerRecord.PBS_AAAP_Owner_Name__c;
                newProperty.PBS_RSAP_Property_Owner_Same_as_Offeror__c = offerRecord.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
                newProperty.PBS_AAAP_Owner_Address__c = offerRecord.PBS_AAAP_Owner_Address__c;
                newProperty.PBS_AAAP_Owner_City__c = offerRecord.PBS_AAAP_Owner_City__c;
                newProperty.PBS_AAAP_Owner_State__c = offerRecord.PBS_AAAP_Owner_State__c;
                newProperty.PBS_AAAP_Owner_Zip__c = offerRecord.PBS_AAAP_Owner_Zip__c;
                newProperty.PBS_AAAP_OFFEROR_INTEREST__c = offerRecord.PBS_AAAP_OFFEROR_INTEREST__c;
                newProperty.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = offerRecord.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
                newProperty.PBS_AAAP_Parking_Onsite__c = offerRecord.PBS_AAAP_Parking_Onsite__c;
                newProperty.PBS_AAAP_DUNS_Number__c = offerRecord.PBS_AAAP_DUNS_Number__c;
                if(existOffer.RecordType.Name == 'RSAP')
                {
                  newproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_RSAP_Year_Built__c; 
                  newproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_RSAP_Renovation_Year__c;
                  newproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c; 
                  newproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c;
                }
                else if(existOffer.RecordType.Name == 'AAAP')
                {
                   newproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c; 
                   newproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c; 
                }
                insert newProperty;
               
                offerRecord.Property__c = newProperty.Id;
    

           }
           else
           {
               PBS_AAAP_Property__c existproperty = [SELECT Id, PBS_AAAP_Building_Name__c,PBS_AAAP_State__c,PBS_AAAP_Street_Address__c,PBS_AAAP_City__c,PBS_AAAP_Common_Area_Factor__c,PBS_AAAP_Country__c,PBS_AAAP_County__c,PBS_AAAP_OFFICE_SPACE_RSF__c,PBS_AAAP_isBuildingProblem__c,PBS_AAAP_LEGACY_X_CO_ORD__c,PBS_AAAP_User_Defined_Address__c,PBS_AAAP_Legacy_Y_CO_ORD__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c,PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c,PBS_AAAP_Monthly_cost_nonres_gar_park__c,PBS_AAAP_Monthly_cost_nonres_sur_park__c,PBS_AAAP_Monthly_cost_res_gar_park__c,PBS_AAAP_Monthly_cost_res_sur_park__c,PBS_AAAP_floors_Suites_in_Offered_Space__c,PBS_AAAP_OFFEROR_INTEREST__c,PBS_AAAP_OFFEROR_INTEREST_OTHER__c,PBS_AAAP_GARAGE_SPACE_RSF__c,OwnerId,PBS_AAAP_Parking_Onsite__c,Name,PBS_AAAP_Owner_City__c,PBS_AAAP_Owner_Name__c,PBS_RSAP_Property_Owner_Same_as_Offeror__c,PBS_AAAP_Owner_State__c,PBS_AAAP_Owner_Address__c,PBS_AAAP_Owner_Zip__c,PBS_AAAP_HVAC_HRS_ON_SAT_END__c,PBS_AAAP_HVAC_HRS_ON_SAT_START__c,PBS_AAAP_HVAC_HRS_ON_SUN_END__c,PBS_AAAP_HVAC_HRS_ON_SUN_START__c,PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c,PBS_AAAP_GEN_PURPOSE_RENTABLE__c,PBS_AAAP_Total_Park_Spaces_Offered__c,PBS_AAAP_Total_Structured_Parking_Spaces__c,PBS_AAAP_Total_Surface_Parking_Spaces__c,PBS_AAAP_DUNS_Number__c,PBS_AAAP_RETAIL_SPACE_RSF__c,PBS_AAAP_X_CO_ORD__c,PBS_AAAP_Y_CO_ORD__c,PBS_AAAP_Renovation_Year__c
                             ,PBS_AAAP_Year_Built__c,PBS_AAAP_ZipCode__c FROM PBS_AAAP_Property__c  WHERE Id = :existOffer.Property__c  LIMIT 1];
                
                existproperty.PBS_AAAP_Owner_Name__c = offerRecord.PBS_AAAP_Owner_Name__c;
                existproperty.PBS_RSAP_Property_Owner_Same_as_Offeror__c = offerRecord.PBS_RSAP_Property_Owner_Same_as_Offeror__c;
                existproperty.PBS_AAAP_Owner_Address__c = offerRecord.PBS_AAAP_Owner_Address__c;
                existproperty.PBS_AAAP_Owner_City__c = offerRecord.PBS_AAAP_Owner_City__c;
                existproperty.PBS_AAAP_Owner_State__c = offerRecord.PBS_AAAP_Owner_State__c;
                existproperty.PBS_AAAP_Owner_Zip__c = offerRecord.PBS_AAAP_Owner_Zip__c;
                existproperty.PBS_AAAP_OFFEROR_INTEREST__c = offerRecord.PBS_AAAP_OFFEROR_INTEREST__c;
                existproperty.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = offerRecord.PBS_AAAP_OFFEROR_INTEREST_OTHER__c;
               	existproperty.PBS_AAAP_Building_Name__c = offerRecord.PBS_AAAP_Building_Name__c;
               	existproperty.PBS_AAAP_Street_Address__c= offerRecord.PBS_AAAP_Street_Address__c;
                existproperty.PBS_AAAP_City__c = offerRecord.PBS_AAAP_City__c;
                if(offerStateAbbr != null)
                {
                 existproperty.PBS_AAAP_State__c = offerStateAbbr;   
                }
               else{
                existproperty.PBS_AAAP_State__c = offerRecord.PBS_AAAP_State__c;
               }
                existproperty.PBS_AAAP_County__c = offerRecord.PBS_AAAP_County__c;
                existproperty.PBS_AAAP_X_CO_ORD__c = offerRecord.PBS_AAAP_X_CO_ORD__c;
                existproperty.PBS_AAAP_Y_CO_ORD__c = offerRecord.PBS_AAAP_Y_CO_ORD__c;
                existproperty.PBS_AAAP_ZipCode__c = offerRecord.PBS_AAAP_ZipCode__c;
                existproperty.PBS_AAAP_floors_Suites_in_Offered_Space__c = offerRecord.PBS_AAAP_floors_Suites_in_Offered_Space__c;
                existproperty.PBS_AAAP_OFFICE_SPACE_RSF__c = offerRecord.PBS_AAAP_OFFICE_SPACE_RSF__c;
                existproperty.PBS_AAAP_RETAIL_SPACE_RSF__c = offerRecord.PBS_AAAP_RETAIL_SPACE_RSF__c;
                existproperty.PBS_AAAP_GARAGE_SPACE_RSF__c = offerRecord.PBS_AAAP_GARAGE_SPACE_RSF__c;
                existproperty.PBS_AAAP_GEN_PURPOSE_RENTABLE__c = offerRecord.PBS_AAAP_GEN_PURPOSE_RENTABLE__c;
                existproperty.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c = offerRecord.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c;
                if(pageName != 'Offer-Owner' && pageName != 'Offer-RLP')
                {
                existproperty.PBS_AAAP_Common_Area_Factor__c = offerRecord.PBS_AAAP_Building_Common_Area_Factor__c;
                }
                existproperty.PBS_AAAP_Total_Surface_Parking_Spaces__c = offerRecord.PBS_AAAP_Total_Surface_Parking_Spaces__c;
                existproperty.PBS_AAAP_Total_Structured_Parking_Spaces__c = offerRecord.PBS_AAAP_Total_Structured_Parking_Spaces__c;
                existproperty.PBS_AAAP_Total_Park_Spaces_Offered__c = offerRecord.PBS_AAAP_Total_Park_Spaces_Offered__c;
                if(existOffer.RecordType.Name == 'RSAP')
                {
                  existproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_RSAP_Year_Built__c; 
                  existproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_RSAP_Renovation_Year__c;
                  existproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c; 
                  existproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c;
                }
                else if(existOffer.RecordType.Name == 'AAAP')
                {
                   existproperty.PBS_AAAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c; 
                   existproperty.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c; 
                }
                existproperty.PBS_AAAP_User_Defined_Address__c = offerRecord.PBS_AAAP_User_Defined_Address__c;
                existproperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c = offerRecord.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c;
                existproperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c = offerRecord.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c;
                existproperty.PBS_AAAP_HVAC_HRS_ON_SAT_START__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SAT_START__c;
                existproperty.PBS_AAAP_HVAC_HRS_ON_SAT_END__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SAT_END__c;
                existproperty.PBS_AAAP_HVAC_HRS_ON_SUN_START__c = offerRecord.PBS_AAAP_HVAC_HRS_ON_SUN_START__c;
                existproperty.PBS_AAAP_HVAC_HRS_ON_SUN_END__c =offerRecord.PBS_AAAP_HVAC_HRS_ON_SUN_END__c;
                
                existproperty.PBS_AAAP_Parking_Onsite__c = offerRecord.PBS_AAAP_Parking_Onsite__c;
                existproperty.PBS_AAAP_DUNS_Number__c = offerRecord.PBS_AAAP_DUNS_Number__c;
               
               update existproperty;
           }
         if(existOffer.RecordType.Name == 'RSAP')
          { 
              offerRecord.PBS_AAAP_Number_of_floors__c = null;
              offerRecord.PBS_RSAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c;
              offerRecord.PBS_RSAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c;
              offerRecord.PBS_AAAP_Renovation_Year__c = null;
              offerRecord.PBS_AAAP_Year_Built__c = null;
              
          }
          else if(existOffer.RecordType.Name == 'AAAP')
          { 
              offerRecord.PBS_AAAP_floors_Suites_in_Offered_Space__c = offerRecord.PBS_AAAP_floors_Suites_in_Offered_Space__c;
              offerRecord.PBS_RSAP_Renovation_Year__c = null;
              offerRecord.PBS_RSAP_Year_Built__c = null;
              offerRecord.PBS_AAAP_Number_of_floors__c = offerRecord.PBS_AAAP_floors_Suites_in_Offered_Space__c;
              offerRecord.PBS_AAAP_Renovation_Year__c = offerRecord.PBS_AAAP_Renovation_Year__c;
              offerRecord.PBS_AAAP_Year_Built__c = offerRecord.PBS_AAAP_Year_Built__c;
          }
          
                  
        update offerRecord;
        resultOfUpdateOffer.isSuccess = true;
            }
            catch(DMLException e){
                resultOfUpdateOffer.addErrorMessage(e.getDmlMessage(0));
            }
        }
        resultOfUpdateOffer.offerId = offerRecord.Id;
        resultOfUpdateOffer.propId = offerRecord.Property__c;
        return resultOfUpdateOffer;
    }

    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getGisConfig() {
        // Fetch configuration data from custom settings, custom metadata, or other sources
        String mGisToken ='';
        String mGisUrlPrefix='';
        String mGisLocatorUrl='';
        String mGisLocator='';
        Map<String, String> config = new Map<String, String>();
        if (APIArcGISHelper.runningInSandbox()) {
            mGisToken = APIArcGISHelper.getArcGISToken(APIArcGISHelper.getRequest('Sandbox'));
            mGisUrlPrefix = APIArcGISHelper.GIS_URL_PREFIX;
            mGisLocatorUrl = APIArcGISHelper.GIS_LOCATOR_URL;
            mGislocator = APIArcGISHelper.GIS_LOCATOR;
        } else {
            mGisToken = APIArcGISHelper.getArcGISToken(APIArcGISHelper.getRequest('Production'));
            mGisUrlPrefix = APIArcGISHelper.GIS_URL_PREFIX;
            mGisLocatorUrl = APIArcGISHelper.GIS_LOCATOR_URL;
            mGislocator = APIArcGISHelper.GIS_LOCATOR;
        }
        config.put('myGisUrlPrefix', mGisUrlPrefix);
        config.put('myGisLocatorUrl', mGisLocatorUrl);
        config.put('myGisLocator', mGislocator);
        config.put('myGisToken', mGisToken); // Example token, replace with actual token fetching logic
        
        return config;
    }
    
    @AuraEnabled
    public static string callGetCommunityURL(String modifiedPageUrl) {
        return PBS_AAAP_Utility.getCommunityURL(modifiedPageUrl);
    }
    
    
    public static Map<String, String> STATE_ABBREVIATIONS = new Map<String, String>{
        'Alabama' => 'AL', 'Alaska' => 'AK', 'Arizona' => 'AZ', 'Arkansas' => 'AR',
        'California' => 'CA', 'Colorado' => 'CO', 'Connecticut' => 'CT', 'Delaware' => 'DE',
        'Florida' => 'FL', 'Georgia' => 'GA', 'Hawaii' => 'HI', 'Idaho' => 'ID',
        'Illinois' => 'IL', 'Indiana' => 'IN', 'Iowa' => 'IA', 'Kansas' => 'KS',
        'Kentucky' => 'KY', 'Louisiana' => 'LA', 'Maine' => 'ME', 'Maryland' => 'MD',
        'Massachusetts' => 'MA', 'Michigan' => 'MI', 'Minnesota' => 'MN', 'Mississippi' => 'MS',
        'Missouri' => 'MO', 'Montana' => 'MT', 'Nebraska' => 'NE', 'Nevada' => 'NV',
        'New Hampshire' => 'NH', 'New Jersey' => 'NJ', 'New Mexico' => 'NM', 'New York' => 'NY',
        'North Carolina' => 'NC', 'North Dakota' => 'ND', 'Ohio' => 'OH', 'Oklahoma' => 'OK',
        'Oregon' => 'OR', 'Pennsylvania' => 'PA', 'Rhode Island' => 'RI', 'South Carolina' => 'SC',
        'South Dakota' => 'SD', 'Tennessee' => 'TN', 'Texas' => 'TX', 'Utah' => 'UT',
        'Vermont' => 'VT', 'Virginia' => 'VA', 'Washington' => 'WA', 'West Virginia' => 'WV',
        'Wisconsin' => 'WI', 'Wyoming' => 'WY'
    };

    @AuraEnabled
    public static String getAbbreviation(String fullStateName) {
        if (String.isBlank(fullStateName)) return '';
        return STATE_ABBREVIATIONS.get(fullStateName.trim());
    }

    
    @AuraEnabled
    public static PBS_AAAP_Property__c getPropertyDetails(String proId) { 
        return [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate,
                LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, ConnectionReceivedId,
                ConnectionSentId, PBS_AAAP_City__c, PBS_AAAP_Country__c, PBS_AAAP_County__c, PBS_AAAP_LEGACY_XY__c, 
                PBS_AAAP_LEGACY_X_CO_ORD__c, PBS_AAAP_Legacy_Y_CO_ORD__c, PBS_AAAP_MetroWalkable__c, 
                PBS_AAAP_State__c, PBS_AAAP_Street_Address__c, PBS_AAAP_User_Defined_Address__c,PBS_AAAP_X_CO_ORD__c, PBS_AAAP_Y_CO_ORD__c, PBS_AAAP_ZipCode__c, 
                PBS_AAAP_isBuildingProblem__c, PBS_AAAP_Building_Name__c, PBS_AAAP_floors_Suites_in_Offered_Space__c, 
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c, PBS_AAAP_OFFICE_SPACE_RSF__c, PBS_AAAP_RETAIL_SPACE_RSF__c, 
                PBS_AAAP_GARAGE_SPACE_RSF__c, PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c, PBS_AAAP_Total_Surface_Parking_Spaces__c, 
                PBS_AAAP_Total_Structured_Parking_Spaces__c, PBS_AAAP_Parking_Onsite__c, PBS_AAAP_Total_Park_Spaces_Offered__c, 
                PBS_AAAP_Monthly_cost_res_gar_park__c, PBS_AAAP_Monthly_cost_nonres_gar_park__c, PBS_AAAP_Monthly_cost_res_sur_park__c, 
                PBS_AAAP_Monthly_cost_nonres_sur_park__c, PBS_AAAP_Year_Built__c, PBS_AAAP_Renovation_Year__c, PBS_AAAP_Owner_Name__c, 
                PBS_AAAP_Owner_Address__c, PBS_AAAP_Owner_City__c, PBS_AAAP_Owner_Zip__c, PBS_RSAP_Property_Owner_Same_as_Offeror__c, 
                PBS_AAAP_OFFEROR_INTEREST__c, PBS_AAAP_OFFEROR_INTEREST_OTHER__c, PBS_AAAP_DUNS_Number__c, PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c, 
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c, PBS_AAAP_HVAC_HRS_ON_SAT_START__c, PBS_AAAP_HVAC_HRS_ON_SAT_END__c, 
                PBS_AAAP_HVAC_HRS_ON_SUN_START__c, PBS_AAAP_HVAC_HRS_ON_SUN_END__c, PBS_AAAP_Owner_State__c, 
                PBS_AAAP_Common_Area_Factor__c FROM PBS_AAAP_Property__c  WHERE Id = :proId ];
    }

    @AuraEnabled
    public static ResponseWrapper validateAllPropertyDetails(String propertyId, List<String> pages) {
        PBS_AAAP_Property__c submitProperty = getPropertyDetails(propertyId);
        ResponseWrapper responseWrapperObj1 = new ResponseWrapper();
        for(String page : pages){
            ResponseWrapper responseWrapperObj2 = validateProperty(submitProperty,new List<String>{page});
            if(responseWrapperObj2.errorMessages.size() > 0 ){
                responseWrapperObj1.errorMessages.addAll(responseWrapperObj2.errorMessages);
            }
        }
        if(responseWrapperObj1.errorMessages.size() == 0 ){
            responseWrapperObj1.isSuccess = true;
        }
        return responseWrapperObj1;
    }
    @AuraEnabled
    public static ResponseWrapper validateProperty(PBS_AAAP_Property__c submitProperty, List<String> pages) {
        ResponseWrapper response = new ResponseWrapper();
        List<PBS_Leasing_Required_Offer_Fields__mdt> requiredPropertyFields = [SELECT Id, Page_name__c,Object_Name__c, Order_Number__c, Error_Message__c, Filter__c FROM PBS_Leasing_Required_Offer_Fields__mdt WHERE Object_Name__c =:'PBS_AAAP_Property__c' AND DeveloperName != Null AND Page_name__c In:pages Order By Page_name__c, Order_Number__c];
        for(PBS_Leasing_Required_Offer_Fields__mdt requiredPropertyField : requiredPropertyFields){
            Integer countOfPassedConditions = 0;
            // Handle 'OR' conditions in the filter
            if(requiredPropertyField.Filter__c.contains(('||'))){
                System.debug('see the split'+ requiredPropertyField.Filter__c.split(('\\|\\|')).size());
                for(String filter : requiredPropertyField.Filter__c.split(('\\|\\|'))){
                    System.debug('seefilter '+filter);
                    // Validate based on equality and null checks
                    if(filter.contains('==')){
                        List<String> conditionParts = filter.split('==');
                        Object obj;
                        System.debug(submitProperty.get(conditionParts[0].trim()));
                        System.debug(conditionParts[1].trim());
                        System.debug(submitProperty.get(conditionParts[0].trim()) == conditionParts[1].trim());
                        if(conditionParts[1].trim() == 'null' && submitProperty.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(String.valueOf(submitProperty.get(conditionParts[0].trim())) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                    // Validate based on less than or equal to condition
                    else if(filter.contains('<=')){
                        List<String> conditionParts = filter.split('<=');
                        if(submitProperty.get(conditionParts[0].trim()) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                }
                // If any condition passes, add the error message to the response
                if(countOfPassedConditions > 0){
                    response.addErrorMessage(requiredPropertyField.Error_Message__c);
                }
            }
            // Handle 'AND' conditions in the filter
            else{
                for(String filter : requiredPropertyField.Filter__c.split('&&')){
                     // Validate based on equality and null checks
                    if(filter.contains('==')){
                        System.debug(requiredPropertyField.Error_Message__c + filter);
                        List<String> conditionParts = filter.split('==');
                        Object obj;
                        if(conditionParts[1].trim().contains('\'')){
                            conditionParts[1] = conditionParts[1].replaceAll('\'','');
                        }
                        System.debug(conditionParts[1].trim());
                        System.debug(submitProperty.get(conditionParts[0].trim()));
                        System.debug(submitProperty.get(conditionParts[0].trim()) == conditionParts[1].trim());
                        if(conditionParts[1].trim() == 'null' && submitProperty.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(String.valueOf(submitProperty.get(conditionParts[0].trim())) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                }
                if(countOfPassedConditions == requiredPropertyField.Filter__c.split('&&').size()){
                    response.addErrorMessage(requiredPropertyField.Error_Message__c);
                }
            }       
            
        }
        if (pages.contains('Offer-Overview')) {
            if(submitProperty.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > submitProperty.PBS_AAAP_GEN_PURPOSE_RENTABLE__c){
                response.addErrorMessage('Overview Page: 3. The total amount of ANSI/BOMA Occupant Area (ABOA) SF in the building cannot be greater than the total rentable square feet (RSF) in the building #2d.');
            }
            if(submitProperty.PBS_AAAP_Year_Built__c == '' || submitProperty.PBS_AAAP_Year_Built__c == null){
                response.addErrorMessage('Overview Page: 6. In what year was the original building construction completed and ready for initial occupancy? is required.');
            }
            if(String.isEmpty(submitProperty.PBS_AAAP_Renovation_Year__c) || submitProperty.PBS_AAAP_Renovation_Year__c.trim() == ''){
                response.addErrorMessage('Overview Page: 7. Provide the year and a brief description of the last major building renovation, if applicable is required.');
            }
            if(submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == Null || submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == ''){
                response.addErrorMessage('Overview Page: 8. Monday - Friday Hours Start is required.');
            }
            if(submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == Null || submitProperty.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == ''){
                response.addErrorMessage('Overview Page: 8. Monday - Friday Hours End is required.');
            }
        } else if (pages.contains('Offer-Owner') ){
            if(submitProperty.PBS_AAAP_OFFEROR_INTEREST__c != Null && submitProperty.PBS_AAAP_OFFEROR_INTEREST__c == 'Other' && (submitProperty.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == Null || submitProperty.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == '')) {
                response.addErrorMessage('Owner Page: 6. A value of "Other" for relationship as the offeror requires the "Other:" free-form text description.');
            }
        }
        return response;
    }
    @AuraEnabled
    public static ResponseWrapper validateOffer(PBS_AAAP_Offer__c submitoffer, String pageName) {
        ResponseWrapper response = new ResponseWrapper();
        System.debug('submitoffer>>>>>>>'+submitoffer);
        List<PBS_Leasing_Required_Offer_Fields__mdt> requiredOfferFields = [SELECT Id, Page_name__c,Object_Name__c, Order_Number__c, Error_Message__c, Filter__c FROM PBS_Leasing_Required_Offer_Fields__mdt WHERE Object_Name__c =:'PBS_AAAP_Property__c' AND DeveloperName != Null AND Page_name__c=:pageName Order By Page_name__c, Order_Number__c];
        System.debug('requiredOfferFields>>>>>>'+requiredOfferFields);
        for(PBS_Leasing_Required_Offer_Fields__mdt requiredOfferField : requiredOfferFields){
            Integer countOfPassedConditions = 0;
                    if(requiredOfferField.Filter__c.contains('==')){
                        List<String> conditionParts = requiredOfferField.Filter__c.split('==');
                        Object obj;
                        if(conditionParts[1].trim() == 'null' && submitoffer.get(conditionParts[0].trim()) == obj){
                            countOfPassedConditions++;
                        }else if(submitoffer.get(conditionParts[0].trim()) == conditionParts[1].trim()){
                            countOfPassedConditions++;
                        }
                    }
                if(countOfPassedConditions > 0){
                    response.addErrorMessage(requiredOfferField.Error_Message__c);
                }
        }
        /*if(pageName == 'Offer-Owner') {
           if(submitoffer.PBS_AAAP_OFFEROR_INTEREST__c != Null && submitoffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other' && (submitoffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == Null || submitoffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == '')) {
                response.addErrorMessage('Owner Page: 6. A value of "Other" for relationship as the offeror requires the "Other:" free-form text description.');
            }
        }*/
        if (pageName == 'Offer-Overview') {
            if(submitoffer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > submitoffer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c){
                response.addErrorMessage('Overview Page: 3. The total amount of ANSI/BOMA Occupant Area (ABOA) SF in the building cannot be greater than the total rentable square feet (RSF) in the building #2d.');
            }
            if(submitoffer.PBS_AAAP_Year_Built__c == '' || submitoffer.PBS_AAAP_Year_Built__c == null){
                response.addErrorMessage('Overview Page: 6. In what year was the original building construction completed and ready for initial occupancy? is required.');
            }
            if(String.isEmpty(submitoffer.PBS_AAAP_Renovation_Year__c) || submitoffer.PBS_AAAP_Renovation_Year__c.trim() == ''){
                response.addErrorMessage('Overview Page: 7. Provide the year and a brief description of the last major building renovation, if applicable is required.');
            }
            if(submitoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == Null || submitoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c  == ''){
                response.addErrorMessage('Overview Page: 8. Monday - Friday Hours Start is required.');
            }
            if(submitoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == Null || submitoffer.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c == ''){
                response.addErrorMessage('Overview Page: 8. Monday - Friday Hours End is required.');
            }
        } else if (pageName == 'Offer-Owner'){
            if(submitoffer.PBS_AAAP_OFFEROR_INTEREST__c != Null && submitoffer.PBS_AAAP_OFFEROR_INTEREST__c == 'Other' && (submitoffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == Null || submitoffer.PBS_AAAP_OFFEROR_INTEREST_OTHER__c == '')) {
                response.addErrorMessage('Owner Page: 6. A value of "Other" for relationship as the offeror requires the "Other:" free-form text description.');
            }
        }        
        return response;
    }
    // Helper class to store the response of the validation process
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

    Public Class ResultWrapper{
        @AuraEnabled
        Public List<PBS_AAAP_Property__c> propList;
    }
}