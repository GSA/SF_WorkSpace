global with sharing class PBS_AAAP_RLPSearchController {

    public string selectedRLPNumber { get; set; }
    public string categorieType { get; set; }
    public string RLPStatusType { get; set; }
    public string RLPTitle { get; set; }
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

    public PBS_AAAP_RLPSearchController() {
        showSearchForm = true;
    }

    public void backToSearch() {
        showSearchForm = true;
        seqNumListAmendments = null;
        seqNumList = null;
    }

    public List<SelectOption> getRlps() {
        List<SelectOption> options = new List<SelectOption>();
        List<PBS_AAAP_RLP__c> allRLPs;
        Id RecTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
        allRLPs = [SELECT id, PBS_AAAP_RLP_Number__c FROM PBS_AAAP_RLP__c WHERE PBS_AAAP_STATUS__c = 'Posted/active' AND RecordTypeId != :RecTypeId];

        options.add(new SelectOption('All', 'All'));
        if (allRLPs != null) {
            for (PBS_AAAP_RLP__c rlp : allRLPs) {
                if(rlp.PBS_AAAP_RLP_Number__c != NULL) {
                    options.add(new SelectOption(rlp.PBS_AAAP_RLP_Number__c, rlp.PBS_AAAP_RLP_Number__c));
                }
            }
        }
        return options;

    }
    public List<SelectOption> getCategories() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        options.add(new SelectOption('Office', 'Office'));
        options.add(new SelectOption('Warehouse', 'Warehouse'));
        return options;
    }
    public List<SelectOption> getRLPStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        options.add(new SelectOption('Canceled', 'Canceled'));
        options.add(new SelectOption('Posted/active', 'Posted/active'));
        options.add(new SelectOption('Replaced', 'Replaced'));
        return options;
    }
    public List<SelectOption> getRegions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
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


    public void actionSearchRLP() {
        rlpList = null;
        rlpList = new List<PBS_AAAP_RLP__c>();
        showSearchForm = true;
        string rlpNumber = '%';
        string catgry = '%';
        string region = '%';
        string rlpstatus = '%';
        string title = '%';
        if (selectedRLPNumber != 'All') {
            rlpNumber = '%' + selectedRLPNumber + '%';
        }
        if (categorieType != 'All') {
            catgry = '%' + categorieType + '%';
        }
        if (selectedRegion != 'All') {
            region = '%' + selectedRegion + '%';
        }
        if (RLPStatusType != 'All') {
            rlpstatus = '%' + RLPStatusType + '%';
        }
        if (RLPTitle != null) {
            title = '%' + RLPTitle + '%';
        }

        Id RecTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();

        rlpList = [
                SELECT id, CreatedDate, PBS_AAAP_RLP_Number__c, PBS_AAAP_Region__c, PBS_AAAP_Category__c, PBS_AAAP_Title__c, PBS_AAAP_STATUS__c
                FROM PBS_AAAP_RLP__c
                WHERE (PBS_AAAP_RLP_Number__c LIKE :STRING.escapeSingleQuotes(rlpNumber)
                AND PBS_AAAP_Category__c LIKE :STRING.escapeSingleQuotes(catgry)
                AND PBS_AAAP_Region__c LIKE :STRING.escapeSingleQuotes(region)
                AND PBS_AAAP_STATUS__c LIKE :STRING.escapeSingleQuotes(rlpstatus)
                AND PBS_AAAP_Title__c LIKE :STRING.escapeSingleQuotes(title)
                AND PBS_AAAP_STATUS__c != 'Draft'
                AND RecordTypeId != :RecTypeId)
        ];

        if (rlpList.size() > 0) {
            showRLPTable = true;
            showMessage = false;

        } else {
            noRecordsFound = 'No records found for your search criteria';
            showRLPTable = false;
            showMessage = true;
        }

    }

    public void actionShowRLP() {
        
        if (rlpID != null && rlpID != '') {
            
            standardAttachmentsList = null;
            amendmentAttachmentsList = null;
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
                    SELECT Name, PBS_AAAP_Title__c, PBS_AAAP_RLP__c, PBS_AAAP_Attachment_Type__c, RLP_Attachment_Name__c, Other_Attachment_Name__c, (SELECT id, ContentDocumentId, ContentDocument.Createddate, ContentDocument.Title,  ContentDocument.LatestPublishedVersionId, ContentDocument.LatestPublishedVersion.Public_Link__c  FROM ContentDocumentLinks limit 1)
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

    }

    public class sequenceNumber {
        public integer i { get; set; }
        public PBS_AAAP_RLP_Attachments__c rlpratts { get; set; }

        public sequenceNumber(integer j, PBS_AAAP_RLP_Attachments__c att) {
            i = j;
            rlpratts = att;
        }
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
        //Here we are querying all files that are related to PBS_AAAP_RLP_Attachments__c records
        for(ContentDocumentLink contentDocumentLinkRecord : [SELECT Id, LinkedEntityId, ContentDocumentId, ContentDocument.Title, ContentDocument.LatestPublishedVersion.PathOnClient, ContentDocument.LatestPublishedVersion.VersionData FROM ContentDocumentLink Where LinkedEntityId In :rlpAttachmentIds]){
            //Here we are setting data in AttachmentWrapper object and adding it lstAttachmentWrapper
            AttachmentWrapper wrapper = new AttachmentWrapper();
            wrapper.attName = contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.PathOnClient;
            System.debug(EncodingUtil.base64Encode(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData));
            wrapper.attEncodedBody = EncodingUtil.base64Encode(contentDocumentLinkRecord.ContentDocument.LatestPublishedVersion.VersionData);
            lstAttachmentWrapper.add(wrapper);
        }
        return lstAttachmentWrapper;
    }

    public class AttachmentWrapper {
        public String attEncodedBody { get; set; }
        public String attName { get; set; }
    }


}