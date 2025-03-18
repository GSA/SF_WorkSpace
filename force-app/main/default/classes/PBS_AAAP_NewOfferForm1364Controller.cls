public class PBS_AAAP_NewOfferForm1364Controller extends PBS_AAAP_PageBaseController {

    public Id offerId { get; set; }
    public PBS_AAAP_Offer__c offer { get; set; }
    public Boolean isValidUser { get; set; }
    public Boolean isValidOfferId { get; set; }

    public String RLPNumber { get; set; }
    public String sysDate { get; set; }
    public String userType { get; set; }
    public User userdetail { get; set; }
    public String offerCreatedBy { get; set; }
    public List<PBS_AAAP_Space__c> spaceList { get; set; }
    public List<PBS_AAAP_Rate__c> rateList { get; set; }
    public String CAF { get; set; }
    public String parkingOnsite { get; set; }
    public String energyStarCertDate { get; set; }
    public String fireLifeMeets { get; set; }
    public String accessibility { get; set; }
    public String asbestos { get; set; }
    public String floodPlains { get; set; }
    public String seismicStatement { get; set; }
    public String freeRentOffered { get; set; }
    public String email { get; set; }
    
    public PBS_AAAP_NewOfferForm1364Controller(){
        
        userType = UserInfo.getUserType(); 
        if (userType == 'Guest') { 
            if (!isValidUser()) { 
                return; 
            }   
        }
        
        logConstructorStart('PBS_AAAP_NewOfferForm1364Controller started...');

        offerId = ApexPages.currentPage().getParameters().get('offerId');
        if (offerId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing Offer ID. Please try again.'));
            isValidOfferId = false;
            return;
        } else {
            try {
                offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
                offerCreatedBy = offer.CreatedById;
            } catch (Exception ex) {
                System.debug(ex.getCause() + ' with message ' + ex.getMessage() + ' caught calling PBS_AAAP_GlobalContstants.getOfferDetail().');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Offer ID. Please try again.'));
                isValidOfferId = false;
                return;
            }
        }
        isValidOfferId = true;

        if (userType.contains('Portal')) {
            if (offerCreatedBy == UserInfo.getUserId()) {
                isValidUser = true;
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, PBS_AAAP_GlobalConstants.ERROR_INAVLID_ACCESS_OWNERSHIP);
                Apexpages.addMessage(myMsg);
                isValidUser = false;
                return;
            }
        } else {
            isValidUser = true;
        }  
              
        userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City,u.Contact.PBS_AAAP_Company__c FROM User u WHERE u.id = :offerCreatedBy];
        
        RLPNumber = offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
        sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ? (offer.PBS_AAAP_Offer_Submission_Date__c.month() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.day() + '-' + offer.PBS_AAAP_Offer_Submission_Date__c.year()) : '';
        if (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0) {
            CAF = String.valueOf(((offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c - offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c) / offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c * 100).setScale(2)) + ' %';
        } else {
            CAF = 'N/A';
        }
        parkingOnsite = offer.PBS_AAAP_Parking_Onsite__c;
        energyStarCertDate = '';
        if (offer.PBS_AAAP_CERTIFICATION_DATE__c != null) {
            // J. Rogers 5/10/23  SFWS-2601
            // Energy Star Certification Date is not a Datetime field.  Changing the formula.
            // energyStarCertDate = ((DateTime) offer.PBS_AAAP_CERTIFICATION_DATE__c).format('MM/dd/yyyy');
            energyStarCertDate =  offer.PBS_AAAP_CERTIFICATION_DATE__c.format();
        }
        fireLifeMeets = offer.PBS_AAAP_Fire_Life_Meets__c;
        accessibility = offer.PBS_AAAP_Accessibility__c;
        asbestos = offer.PBS_AAAP_Asbestos__c;
        floodPlains = offer.PBS_AAAP_Flood_Plains__c;
        seismicStatement = offer.PBS_AAAP_Seismic_Statement__c;

        spaceList = PBS_AAAP_GlobalConstants.getSpaces(offerId);
        rateList = PBS_AAAP_GlobalConstants.getRatesandSpace(offerId);
        freeRentOffered = 'No';
        for (PBS_AAAP_Rate__c rate : rateList) {
            if (rate.PBS_AAAP_NO_OF_MONTHS_FREE_FIRM_TERM__c > 0) {
                freeRentOffered = 'Yes';
                break;
            }
        }
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
        email = tempEmail;
        logConstructorEnd('PBS_AAAP_NewOfferForm1364Controller ended.');

    }
    
    private Boolean isValidUser() {  

        string paramSessionKey = getQueryParamAsString('sesid');    
        string sessionOfferKey = fetchOfferKey();
	string isFromOfferAtt = getQueryParamAsString('isFromOfferAtt');
        if(isFromOfferAtt == 'true'){
            return true;
        }
        if(paramSessionKey != sessionOfferKey   
                || string.isBlank(sessionOfferKey)  
                || string.isBlank(paramSessionKey)){    
            return false;   
        }  
         
        return true;  
          
    }   
    
    public pageReference isValidUserAction(){   
        
        if (!isValidUser()) { 
            return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page'); 
        }  
         
        return null; 
           
    }
    
    private string fetchOfferKey() {
    
        string ofId = getQueryParamAsString('offerId');
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
        
    }
    
}