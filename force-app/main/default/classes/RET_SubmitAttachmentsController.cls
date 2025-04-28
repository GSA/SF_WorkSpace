public without sharing class RET_SubmitAttachmentsController {
    
    public class MyException extends Exception {}
    
    Static String RET_GREX_API_INTEGRATION_NOTIFICATION='RET_Notification';
    Static String RET_GREX_API_INTEGRATION_NOTIFICATION_NONPROD ='RET_Notification_NonProd';
    Static String RET_GREX_API_INTEGRATION ='RET_GREX_API_Integration';
    
    @AuraEnabled
    public static ReviewAttachmentsResponse reviewAttachments(String leaseNumber) {
        System.debug('Inside reviewAttachments(), leaseNumber = ' + leaseNumber);
        // Initialize the response wrapper class
        ReviewAttachmentsResponse response = new ReviewAttachmentsResponse();
        try {
            // Fetch the most recent Draft Case for the Lease Number and see if any Documents are attached
            Case caseRec = getCase(leaseNumber);
            response.myCase = caseRec !=null? caseRec : null;
            if(caseRec !=null){
                List<RET_Document_Data__c> docs = [SELECT Attachment_Id__c FROM RET_Document_Data__c WHERE Parent_Case__c =: caseRec.Id];
                response.success = docs.size() > 0 ? true : false; 
            }else{
                response.success = false;
            }
        }Catch (Exception e){
            System.debug('caught error: ' + e.getMessage());
            response.addErrorMessage(e.getMessage());
        }
        // Return the response 
        return response;
    }
    
    public class ReviewAttachmentsResponse {
        @AuraEnabled public Boolean success { get; set; }
        @AuraEnabled public List<String> errorMessages { get; set; }
        @AuraEnabled public case myCase { get; set; }
        // Constructor to initialize the response object
        public ReviewAttachmentsResponse() {
            this.success = false;
            this.errorMessages = new List<String>();
            this.myCase = new Case();
        }
        // Method to add an error message to the response
        public void addErrorMessage(String message) {
            this.errorMessages.add(message);
        }
    }
    
    public static case getCase(String leaseNumber){
        Case cse = null;
        System.debug('Starting getCaseId() with leaseNumber ' + leaseNumber);
        String leaseId = [SELECT Id FROM PBS_Lease__c WHERE Lease_Number__c =: leaseNumber LIMIT 1].Id;
        String myUserId = UserInfo.getUserId();
        List<Case> caseRec = [SELECT Id,GSA_Contact_Email__c, Status,PBS_Lease__c, RET_Submission_Comments__c  FROM Case WHERE Status = 'Draft' AND PBS_Lease__c =: leaseId AND OwnerId =: myUserId ORDER BY CreatedDate DESC Limit 1];
        if(caseRec.size()>0){
            cse = caseRec[0];
        }
        //Only the RET_UploadAttachmentController Apex class should create a new Draft Case if one is not found for the User and Lease
        //if (caseId == null) {
        //    Case newCase = new Case();
        //    newCase.Status = 'Draft';
        //    newCase.PBS_Lease__c = leaseId;
        //    insert newCase;
        //    return newCase.Id;
        //} else {
        return cse;
        //}
    }
    
    @AuraEnabled
    public static void submitDocumentsToGREX(String caseId) {
        try{
           
                Datetime currentDateTime = Datetime.now();
                List<RET_Document_Data__c> attachmentRecs = [SELECT Parent_Case__c, Parent_Case__r.Status, Parent_Case__r.Lease_Number__c,Id, Attachment_ID__c, Full_File_Name__c, Document_Category__c, Document_Type__c 
                                                             FROM RET_Document_Data__c
                                                             WHERE Parent_Case__c = :caseId];
             if(attachmentRecs[0].Parent_Case__r.Status == 'Draft'){
                CaseWrapper caseData = new CaseWrapper();
                caseData.caseId = caseId;
                caseData.initialSubmissionDate = currentDateTime;
                caseData.documents = new List<Document>();
                if (attachmentRecs.size() > 0) {
                    caseData.leaseNumber = attachmentRecs[0].Parent_Case__r.Lease_Number__c;
                    for(RET_Document_Data__c docu : attachmentRecs) {
                        Document doc1 = new Document();
                        doc1.attachmentId = docu.Attachment_ID__c !=null ? docu.Attachment_ID__c : null;
                        doc1.fileName = docu.Full_File_Name__c != null? docu.Full_File_Name__c : null ;
                        doc1.documentCategory = docu.Document_Category__c != null ? docu.Document_Category__c : null;
                        doc1.documentType = docu.Document_Type__c !=null ?docu.Document_Type__c : null;
                        caseData.documents.add(doc1); 
                    }
                    system.debug(JSON.serializePretty(caseData) ); 
                    String reqStr =JSON.serializePretty(caseData);
                    //Call GREX Service 
                    String SERVICETYPE =[Select Id, Name, IsSandbox from Organization].IsSandbox == true ? RET_GREX_API_INTEGRATION_NOTIFICATION_NONPROD : RET_GREX_API_INTEGRATION_NOTIFICATION;
                    if(RET_APICallManager.resourceToHandler.containsKey(RET_GREX_API_INTEGRATION) ){
                        RET_APIntegration_Interface GREX_Handler = (RET_APIntegration_Interface) RET_APICallManager.resourceToHandler.get(RET_GREX_API_INTEGRATION).newinstance();
                        GREX_Handler.doHandleRequest(reqStr, SERVICETYPE); 
                        //Update Case after successfull callout
                        Case cs = new case (Id= caseId , Status ='Submitted' ,  RET_Initial_Submission_Date__c = currentDateTime, RET_Last_Submission_Date__c = currentDateTime) ;
                        update cs;
                    }
                }
            }
            else{
                throw new MyException('System Could not find a recent draft case ');
            }
        }Catch (Exception e){
            //sendIntegrationErrorEmail(e.getMessage());
            throw new MyException('Unable to process the request at this time. Please provide following details to admin. '+'/n' + e);
        }
    }  
    
    @TestVisible private static void sendIntegrationErrorEmail(String error) {
        RET_GREX_Integration_Email_Settings__c emailSettings1 = RET_GREX_Integration_Email_Settings__c.getInstance(
            'O&M Integration Failure'
        );
        RET_GREX_Integration_Email_Settings__c emailSettings2 = RET_GREX_Integration_Email_Settings__c.getInstance(
            'GREX Team Integration Failure'
        );
        if (emailSettings1 != null || emailSettings2 != null) {
            try {
                //Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSenderDisplayName(emailSettings1.Sender_Display_Name__c);
                mail.setToAddresses(new List<String>{ emailSettings1.To_Address__c, emailSettings2.To_Address__c });
                mail.setSubject(emailSettings1.Email_Subject__c);
                mail.setHtmlBody(emailSettings1.Email_Body__c + error);
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
                system.debug('**' + mail);
            } catch (Exception e) {
                System.debug(' *** email error: ' + e.getMessage());
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
    
    public class Document { 
        public String attachmentId; 
        public String fileName; 
        public String documentCategory; 
        public String documentType; 
    }
    
    public class CaseWrapper {
        public String caseId;
        public String leaseNumber;
        public Datetime initialSubmissionDate;
        public List<Document> documents;
    }
    
    
}