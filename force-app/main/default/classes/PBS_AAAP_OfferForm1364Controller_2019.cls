//public without sharing class PBS_AAAP_OfferForm1364Controller_2019 extends PBS_AAAP_PageBaseController {//JK removed 12.1.2020
public class PBS_AAAP_OfferForm1364Controller_2019 extends PBS_AAAP_PageBaseController {

    public string folderId {get;set;}
    transient public string strImageBlob {get;set;}
    transient public string strImagename {get;set;}

    public PBS_AAAP_Offer__c offer { get; set; }
    public User userdetail { get; set; }


    public ID offerId { get; set; }
    public string formtype { get; set; }
    public string RLPNumber { get; set; }
    public String sysDate { get; set; }
    public string userName { get; set; }
    public string offerCreatedBy { get; set; }
    public boolean isValidUser { get; set; }
    public List<PBS_AAAP_Space__c> spaceList {get;set;}
    public List<PBS_AAAP_Rate__c> rateList {get;set;}
    public string CAF { get; set; }
    public string userType { get; set; }

    public PBS_AAAP_OfferForm1364Controller_2019() {
        system.debug('\n--UserInfo.getUserType()--'+UserInfo.getUserType());
        
        if(UserInfo.getUserType() == 'Guest' ){
            if(!isValidUser()){
                return;
            }
        }
        logConstructorStart('PBS_AAAP_OfferForm1364Controller');
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        Date currentDate = Date.today();
        formtype = ApexPages.currentPage().getParameters().get('formtype');
        System.debug('UserInfo.UserInfo.getUserRoleId() is ' + UserInfo.getUserRoleId());
        System.debug('UserInfo.getUserType() is ' + UserInfo.getUserType());
        string userType = UserInfo.getUserType();
        if (ApexPages.currentPage().getParameters().get('offerId') != null) {
            try {

                offer = PBS_AAAP_GlobalConstants.getOfferDetail(offerId);
                offerCreatedBy = offer.CREATEDBYID;

            } catch (Exception ex) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Incorrect Offer ID. Please try again.');
                ApexPages.addMessage(myMsg);
                return;
            }
        }
        //added this condition because it is only applicable for extranet users , intranet users can see the page. extranet users always have portal in the userType
        if((userType.contains('Customer')) || (userType.contains('Portal'))){
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
          System.debug('JK offerCreatedBy ' + offerCreatedBy);
        System.debug('JK userID ' + UserInfo.getUserId());
        userdetail = [SELECT u.Title, u.Street, u.State, u.PostalCode, u.Phone, u.Name, u.Id, u.Email, u.City,u.Contact.PBS_AAAP_Company__c FROM User u WHERE u.id = :offerCreatedBy];
        userName = UserInfo.getName();
        
        RLPNumber = offer.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
        //Datetime  mydate = offer.lastmodifieddate;
        //Datetime GMTDate = Datetime.newInstance(mydate.year(),mydate.year().month(),mydate.year().day(),0,0,0);
        //String strConvertedDate = GMTDate.format('MM/dd/yyyy HH:mm','America/New_York');
        sysDate = (offer.PBS_AAAP_Offer_Submission_Date__c != null) ?  (offer.PBS_AAAP_Offer_Submission_Date__c).format() : null;
        //sysDate = sysDate.format('MM/dd/yyyy HH:mm','America/New_York');
        spaceList = PBS_AAAP_GlobalConstants.getSpaces(offerId);
        system.debug('-----------*******'+spaceList);
        rateList = PBS_AAAP_GlobalConstants.getRatesandSpace(offerId);
        //CAF
        if (offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0)
            CAF = String.valueOf((offer.PBS_AAAP_GEN_PURPOSE_RENTABLE__c / offer.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c).setScale(2)); else {
            CAF = 'N/A';
        }
        //System.debug('Spaces: '+spaceList[0].PBS_AAAP_SF_OFFERED__c);
        //System.debug('Spaces base rate: '+spaceList[0].Rates__r[0].PBS_AAAP_BASE_RATE__c);
        //System.debug('Rates: '+rateList);
        logConstructorEnd('PBS_AAAP_OfferForm1364Controller');

    }

    public void captureImage()
    {
        folderId = [SELECT ID
        FROM Folder
        WHERE NAME = 'AAAP Folder'].Id;
        Document d = new Document();
        d.Name = strImagename+'.png';

        Integer strLen = strImageBlob.length() / 2;
        String first = strImageBlob.substring(0, strLen);
        String second = strImageBlob.substring(strLen);
        String first1 = first.replaceFirst('data:image/png;base64,','');
        String concat = first1 + second;
        d.Body = EncodingUtil.base64Decode(concat);

        //d.Body = EncodingUtil.base64Decode(strImageBlob.replaceFirst('data:image/png;base64,',''));
        d.ContentType = 'image/png';
        d.FolderId = folderId;
        d.IsPublic = true;
        insert d;
        PBS_AAAP_relateListSnapCntrl.saveRecIdinCookie(d.Id);
        system.debug('\n--d---'+d);
    }

    string fetchOfferKey(){
        string ofId = getQueryParamAsString('offerId');
        return [select PBS_AAAP_Session_Key__c FROM PBS_AAAP_Offer__c WHERE Id=: ofId].PBS_AAAP_Session_Key__c;
    }

    boolean isValidUser(){
        // getting session id
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
        boolean isValid = isValidUser();
      //  boolean isInternal = (UserInfo.getUserType() == 'Standard');
        userType = UserInfo.getUserType();
      //  if(!isInternal){
          if(userType == 'Guest') {
            if(!isValid){
                return new pageReference('/apex/GenricErrorPage?errormessage=Not Authorized to see this page');
            }
        }
        return null;
    }

}