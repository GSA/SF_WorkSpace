public with sharing class PBS_AAAP_RLPAttachmentsController {

    public PBS_AAAP_RLP_Attachments__c RLPattachment { get; set; }
    public List<PBS_AAAP_RLP_Attachments__c> attachmentsList { get; set; }
    public List<Attachment> attList { get; set; }
    public Attachment att { get; set; }
    public string rlpID { get; set; }


    public PBS_AAAP_RLPAttachmentsController(ApexPages.StandardController sc) {
        if (ApexPages.currentPage().getParameters().get('retURL') != null) {

            rlpID = ApexPages.currentPage().getParameters().get('retURL');
            if (rlpID.startsWith('/')) {
                rlpID = rlpID.substring(1);
            }
            system.debug('***************RLP ID in Constructor:' + rlpID);
            RLPattachment = new PBS_AAAP_RLP_Attachments__c();
            att = new Attachment();
            attachmentsList = [
                    SELECT PBS_AAAP_Title__c, Name,PBS_AAAP_RLP__c, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)
                    FROM PBS_AAAP_RLP_Attachments__c p
                    WHERE p.PBS_AAAP_RLP__c = :rlpID
            ];
            System.debug('::::::::::: Attachments List ::::::::::: ' + attachmentsList);
        }

    }

    public PageReference upload() {


        attachmentsList = null;
        /*String id = ApexPages.currentPage().getParameters().get('retURL');
        if(id.startsWith('/')){
            id = id.substring(1);
        }*/
        System.debug(' **********RLP ID :::::::::: ' + rlpID);
        //RLPattachment.PBS_AAAP_RLP__c = rlpID;

        System.debug('Attachment Type:::::::::::::: ' + RLPattachment.PBS_AAAP_Title__c);

        try {
            insert RLPattachment;
            System.debug('After Attachment Type:::::::::::::: ' + RLPattachment.id);

            att.ParentId = RLPattachment.id;

            insert att;

            attachmentsList = [
                    SELECT PBS_AAAP_Title__c, Name, PBS_AAAP_RLP__c, (SELECT Id, Name, Description, ParentId, createdDate FROM Attachments)
                    FROM PBS_AAAP_RLP_Attachments__c p
                    WHERE p.PBS_AAAP_RLP__c = :rlpID
            ];

        } catch (DMLException e) {
            System.debug('DMLException::::::::' + e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error uploading file'));
            return null;
        } finally {

            att.Body = null;// clears the viewstate
            att = new Attachment();

        }

        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'File uploaded successfully'));
        return null;
    }
}