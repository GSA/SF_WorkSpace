public with sharing class PBS_AAAP_HomePageController {


    // Variables used for User De-Registration
    public String userid { get; set; }
    public String pin { get; set; }

    public string selectedRegion { get; set; }
    public List <PBS_AAAP_RLP__c> rlpList { get; set; }
    public boolean showRLPTable { get; set; }
    public boolean showMessage { get; set; }
    public string noRecordsFound { get; set; }
    public String rlpID { get; set; }    // Stores the RLP ID while redirecting it to an RLP detail page.
    public PBS_AAAP_RLP__c rlpdetail { get; set; }
    public List<PBS_AAAP_RLP_Attachments__c> standardAttachmentsList { get; set; }
    public List<PBS_AAAP_RLP_Attachments__c> amendmentAttachmentsList { get; set; }
    public List<sequenceNumber> seqNumList { get; set; }
    public List<sequenceNumber> seqNumListAmendments { get; set; }
    public boolean showAmendmentsTable { get; set; }
    public boolean showSearchForm { get; set; }
    public String pageURLForRedirection{get;set;}

    public PBS_AAAP_HomePageController() {
        Cookie rlpRegionCookie = ApexPages.currentPage().getCookies().get('rlpRegion');
        Cookie rlpIDCookie = ApexPages.currentPage().getCookies().get('rlpID');
        if(rlpRegionCookie != Null && rlpRegionCookie.getValue() != 'Null'){
            selectedRegion= rlpRegionCookie.getValue();
            actionSearchRLPSite();
            
        }else if(rlpIDCookie != Null && rlpIDCookie.getValue() != 'Null'){
            rlpID = rlpIDCookie.getValue(); 
            actionShowRLPDetail();
        }
        /*
        if (ApexPages.currentPage().getParameters().get('rlpRegion') != null) {
            selectedRegion = ApexPages.currentPage().getParameters().get('rlpRegion');
            system.debug('***************selectedRegion in Constructor:' + selectedRegion);
            actionSearchRLPSite();
        }
        //added by syam ganna 05/19/2016 in case of single rlp directly show the detail page
        else {
            rlpID = ApexPages.currentPage().getParameters().get('rlpID'); 
            actionShowRLPDetail();
        }
*/

    }

    public List<SelectOption> getRegions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'Select a Region'));
        //options.add(new SelectOption('Census', 'Census'));
        options.add(new SelectOption('Region 1', 'Region 1'));
        options.add(new SelectOption('Region 2', 'Region 2'));
        options.add(new SelectOption('Region 3', 'Region 3'));
        options.add(new SelectOption('Region 4', 'Region 4'));
        options.add(new SelectOption('Region 5', 'Region 5'));
        options.add(new SelectOption('Region 6', 'Region 6'));
        options.add(new SelectOption('Region 7', 'Region 7'));
        options.add(new SelectOption('Region 8', 'Region 8'));
        options.add(new SelectOption('Region 9', 'Region 9'));
        options.add(new SelectOption('Region 10', 'Region 10'));
        options.add(new SelectOption('National Capital Region', 'National Capital Region'));
        options.add(new SelectOption('10/5 Term - All Regions', '10/5 Term - All Regions'));
        return options;
    }


    public PageReference actionShowRLPs() {
  
        PageReference pref = null;
        //added by syam ganna 05/19/2016 in case of single rlp directly show the detail page
        rlpList = [
                SELECT id, CreatedDate, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_Category__c, PBS_AAAP_Title__c, PBS_AAAP_STATUS__c
                FROM PBS_AAAP_RLP__c
                WHERE PBS_AAAP_Region__c = :selectedRegion
                AND PBS_AAAP_isActive__c = TRUE
                AND PBS_AAAP_STATUS__c = 'Posted/active'
        ];
         if (rlpList.size() == 1) {
            PBS_AAAP_RLP__c rlpDetails = rlpList.get(0);
            rlpID = rlpDetails.id;
            System.debug('rlpID in actionShowRLPs is **** ' + rlpID);
            //actionShowRLPDetail();
           // pref = Page.PBS_AAAP_SitesRLP;
           // pref.getParameters().put('rlpRegion', null);
           // pref.getParameters().put('rlpID', rlpID);
           // pref.setRedirect(true);
           
           PageReference p = new PageReference(Label.LOP_Community_Base_URL+'AAAP-View-RLP');
            p.getParameters().put('rlpRegion', null);
            p.getParameters().put('rlpID', rlpID);
            p.setRedirect(false);  
             Cookie rlpIDCookie = new Cookie('rlpID',rlpID,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{rlpIDCookie});
             
            pageURLForRedirection = p.getUrl();
             
            Cookie rlpRegionCookie = new Cookie('rlpRegion','Null',null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{rlpRegionCookie});
        }

        else if (selectedRegion != null) {
            PageReference p = new PageReference(Label.LOP_Community_Base_URL+'AAAP-View-RLP');
            p.getParameters().put('rlpRegion', selectedRegion);
            p.setRedirect(false);
            
            Cookie rlpRegionCookie = new Cookie('rlpRegion',selectedRegion,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{rlpRegionCookie});
            
            pageURLForRedirection = p.getUrl();  
            Cookie rlpIDCookie = new Cookie('rlpID','Null',null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{rlpIDCookie});
        
          //  pref = Page.PBS_AAAP_SitesRLP;
          //  pref.getParameters().put('rlpRegion', selectedRegion);
          //  pref.setRedirect(true);
        }
        /*else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Select a Region.');
              ApexPages.addMessage(myMsg);
        }*/
             
       // pageURLForRedirection = p.getUrl();      
        return null;

     
    }

    public void actionSearchRLPSite() {
        rlpList = null;
        rlpList = new List<PBS_AAAP_RLP__c>();
        showSearchForm = true;
		Cookie rlpRegionCookie = new Cookie('rlpRegion',selectedRegion,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{rlpRegionCookie});
        rlpList = [
                SELECT id, CreatedDate, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_Category__c, PBS_AAAP_Title__c, PBS_AAAP_STATUS__c
                FROM PBS_AAAP_RLP__c
                WHERE PBS_AAAP_Region__c = :selectedRegion
                AND PBS_AAAP_isActive__c = TRUE
                AND PBS_AAAP_STATUS__c = 'Posted/active'
        ];

        System.debug('*********** rlp luist:::: ' + rlpList);

        if (rlpList.size() != 0) {
            showRLPTable = true;
            showMessage = false;
        } else {
            noRecordsFound = 'No records found for your search criteria';
            showRLPTable = false;
            showMessage = true;
        }

    }

    public void actionShowRLPDetail() {
        if (rlpID != null && rlpID != '') {
            Boolean isValidate = validateId(rlpID);
            if(isValidate) {
           

            showSearchForm = false;
      //Here we are PBS_AAAP_RLP__c record by rlpID so we can show details onto the page
            rlpdetail = [
                    SELECT id, PBS_AAAP_RLP_Number__c, PBS_AAAP_BAFO_DUE_DATE__c,PBS_AAAP_INITIAL_DUE_DATE__c, PBS_AAAP_EXCEPTION_MONTH_END__c,
                            PBS_AAAP_EXCEPTION_MONTH_BEGIN__c, PBS_AAAP_DEFAULT_MONTH_END__c, PBS_AAAP_DEFAULT_MONTH_BEGIN__c, PBS_AAAP_Title__c,
                            PBS_AAAP_STATUS__c, PBS_AAAP_Category__c, PBS_AAAP_Canceled_Date__c, PBS_AAAP_Canceled_Reason__c, Replaced_RLP__c,
                            PBS_AAAP_Status_Change_Date__c, LastModifiedDate, RLP_Replaced_By__c, PBS_AAAP_Region__c, Replaced_RLP__r.PBS_AAAP_RLP_Number__c
                    FROM PBS_AAAP_RLP__c
                    WHERE id = :rlpID
            ];
            System.debug('rlpID in actionShowRLPDetail is **** ' + rlpID);
            System.debug('********** rlp detail******** ' + rlpdetail);


            // logic for displaying the attachments on the vf page.
            standardAttachmentsList = [
                    SELECT Name, PBS_AAAP_Title__c, PBS_AAAP_RLP__c, PBS_AAAP_Attachment_Type__c, RLP_Attachment_Name__c, Other_Attachment_Name__c, (SELECT id, ContentDocumentId, ContentDocument.Createddate, ContentDocument.Title, ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Public_Link__c  FROM ContentDocumentLinks limit 1)
                    FROM PBS_AAAP_RLP_Attachments__c p
                    WHERE p.PBS_AAAP_RLP__c = :rlpID
                    AND p.PBS_AAAP_Attachment_Type__c != :PBS_AAAP_GlobalConstants.RLP_ATTACHMENT_TYPE order by createddate desc
            ];
            System.debug('::::::::::: Attachments List ::::::::::: ' + standardAttachmentsList);
            seqNumList = new List<sequenceNumber>();
            for (integer i = 0; i < standardAttachmentsList.size(); i++) {
                seqNumList.add(new sequenceNumber(i + 1, standardAttachmentsList[i]));
            }
      //Here we are all related PBS_AAAP_RLP_Attachments__c records
      //and we are also doing sub Query on ContentDocumentLinks so we can show files data onto the page.
            amendmentAttachmentsList = [
                    SELECT Name, PBS_AAAP_Title__c, PBS_AAAP_RLP__c, PBS_AAAP_Attachment_Type__c, RLP_Attachment_Name__c, Other_Attachment_Name__c, (SELECT id, ContentDocumentId, ContentDocument.Createddate, ContentDocument.Title,  ContentDocument.LatestPublishedVersionId,  ContentDocument.LatestPublishedVersion.Public_Link__c  FROM ContentDocumentLinks limit 1)
                    FROM PBS_AAAP_RLP_Attachments__c p
                    WHERE p.PBS_AAAP_RLP__c = :rlpID
                    AND p.PBS_AAAP_Attachment_Type__c = :PBS_AAAP_GlobalConstants.RLP_ATTACHMENT_TYPE
            ];
            if (amendmentAttachmentsList.size() > 0) {
                showAmendmentsTable = true;
                seqNumListAmendments = new List<sequenceNumber>();
                for (integer i = 0; i < amendmentAttachmentsList.size(); i++) {
                    seqNumListAmendments.add(new sequenceNumber(i + 1, amendmentAttachmentsList[i]));
                }
            } else {
                showAmendmentsTable = false;
            }
        }
        
           else
            {
             noRecordsFound = 'No records found for your search criteria';
            showRLPTable = false;
            showMessage = true; 
              showSearchForm = true;
            }
        }

    }

    static public Boolean validateId(String Idparam) {
        String id = String.escapeSingleQuotes(Idparam);
        return ((id.length() == 15 || id.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', id));

    }
    public void backToSearch() {
        showSearchForm = true;
        seqNumListAmendments = null;
        seqNumList = null;
    }

    public class sequenceNumber {
        public integer i { get; set; }
        public PBS_AAAP_RLP_Attachments__c rlpratts { get; set; }

        public sequenceNumber(integer j, PBS_AAAP_RLP_Attachments__c att) {
            i = j;
            rlpratts = att;
        }
    }
    
    @AuraEnabled
    public static String getUserType() {
        system.debug('getUserType() userType = ' + UserInfo.getUserType());
        return UserInfo.getUserType();
    }

    @RemoteAction
    public static List<AttachmentWrapper> DownloadAllFiles(string rlpId) {
        List <AttachmentWrapper> lstAttachmentWrapper = new List <AttachmentWrapper>();
        Set<Id> rlpAttachmentIds = new Set<Id>();
        
        Set<Id> contentDocumentIds = new Set<Id>();
        //Here we are querying all related PBS_AAAP_RLP_Attachments__c records
        for(PBS_AAAP_RLP_Attachments__c rlpAttachmentRecord : [SELECT Id,Name, PBS_AAAP_RLP__c FROM PBS_AAAP_RLP_Attachments__c p WHERE p.PBS_AAAP_RLP__c = :rlpId]){
            rlpAttachmentIds.add(rlpAttachmentRecord.Id);
        }
        System.debug('rlpAttachmentIds');
        System.debug(rlpAttachmentIds);
        //Here we are querying all files that are related to PBS_AAAP_RLP_Attachments__c records
        for(ContentDocumentLink contentDocumentLinkRecord : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersion.PathOnClient, ContentDocument.LatestPublishedVersion.VersionData FROM ContentDocumentLink Where LinkedEntityId In :rlpAttachmentIds]){
            //Here we are setting data in AttachmentWrapper object and adding it lstAttachmentWrapper
            AttachmentWrapper wrapper = new AttachmentWrapper();
            wrapper.attName = contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.PathOnClient;
            System.debug(EncodingUtil.base64Encode(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData));
            wrapper.attEncodedBody = EncodingUtil.base64Encode(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData);
            lstAttachmentWrapper.add(wrapper);
        }
        System.debug(lstAttachmentWrapper);
        return lstAttachmentWrapper;
    }

    public class AttachmentWrapper {
        public String attEncodedBody { get; set; }
        public String attName { get; set; }
    }

}