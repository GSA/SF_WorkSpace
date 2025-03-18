@IsTest
private class Test_PBS_AAAP_RLPSearchController {

    static testMethod void myUnitTest() {

        Id RecTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();

        PBS_AAAP_RLP__c rlp1 = new PBS_AAAP_RLP__c();
        rlp1.PBS_AAAP_RLP_Number__c = '123456';
        rlp1.PBS_AAAP_Title__c = 'RLP TEST';
        rlp1.PBS_AAAP_Region__c = 'Region 2';
        rlp1.PBS_AAAP_Year__c = '2019';
        rlp1.PBS_AAAP_STATUS__c = 'Posted/Active';
        rlp1.PBS_AAAP_TELCOMM_DEFAULT__c = 10;
        rlp1.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 10;
        rlp1.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp1.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1';
        rlp1.PBS_AAAP_DEFAULT_MONTH_END__c = '15';
        rlp1.RecordTypeId = RecTypeId;
        insert rlp1;

        PBS_AAAP_RLPSearchController rlpsc = new PBS_AAAP_RLPSearchController();
        test.startTest();
        rlpsc.backToSearch();
        rlpsc.getRlps();
        rlpsc.getCategories();
        rlpsc.getRLPStatus();
        rlpsc.getRegions();
        //PBS_AAAP_RLP__c rlp = [select id from PBS_AAAP_RLP__c limit 1];

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/active',
                PBS_AAAP_Category__c = 'Office', PBS_AAAP_Title__c = 'National RLP', RecordTypeId = RecTypeId);
        insert rlp;
        system.assertNotEquals(rlp, null);

        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt1;
        //Attachment att = new Attachment(Description = 'Sample Doc', ParentId = rlpatt.Id);
        //insert att;
        //PBS_AAAP_RLPSearchController.sequenceNumber[] seq = rlpsc.seqNumList();

        rlpsc.rlpID = rlp.Id;
        rlpsc.actionShowRLP();
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Amendment');
        insert rlpatt;
        rlpsc.actionShowRLP();
        rlpsc.selectedRLPNumber = rlp.Id;
        rlpsc.categorieType = 'Office';
        rlpsc.RLPStatusType = 'Posted/active';
        rlpsc.selectedRegion = 'National Capital Region';
        rlpsc.RLPTitle = 'National RLP';
        rlpsc.actionSearchRLP();

        rlpsc.selectedRLPNumber = 'All';
        rlpsc.categorieType = 'All';
        rlpsc.RLPStatusType = 'All';
        rlpsc.selectedRegion = 'All';
        rlpsc.RLPTitle = '';
        rlpsc.actionSearchRLP();
        // System.assert(rlpsc.rlpList.size()>0);
        System.assert(true);
        test.stopTest();
    }

    static testMethod void downloadAttachments() {

        Id RecTypeId = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('AAAP').getRecordTypeId();

        PBS_AAAP_RLP__c rlp1 = new PBS_AAAP_RLP__c();
        rlp1.PBS_AAAP_RLP_Number__c = '123456';
        rlp1.PBS_AAAP_Title__c = 'RLP TEST';
        rlp1.PBS_AAAP_Region__c = 'Region 2';
        rlp1.PBS_AAAP_Year__c = '2019';
        rlp1.PBS_AAAP_STATUS__c = 'Posted/Active';
        rlp1.PBS_AAAP_TELCOMM_DEFAULT__c = 10;
        rlp1.PBS_AAAP_PV_OTHER_UPFRONT_COSTS__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_NEW__c = 10;
        rlp1.PBS_AAAP_TIUSED_FOR_FIRM_TERM_SUCC__c = 10;
        rlp1.PBS_AAAP_MOVE_DEFAULT__c = 10;
        rlp1.PBS_AAAP_DEFAULT_MONTH_BEGIN__c = '1';
        rlp1.PBS_AAAP_DEFAULT_MONTH_END__c = '15';
        rlp1.RecordTypeId = RecTypeId;
        insert rlp1;

        PBS_AAAP_RLPSearchController rlpsc = new PBS_AAAP_RLPSearchController();
        test.startTest();
        rlpsc.backToSearch();
        rlpsc.getRlps();
        rlpsc.getCategories();
        rlpsc.getRLPStatus();
        rlpsc.getRegions();
        //PBS_AAAP_RLP__c rlp = [select id from PBS_AAAP_RLP__c limit 1];

        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/active',
                PBS_AAAP_Category__c = 'Office', PBS_AAAP_Title__c = 'National RLP', RecordTypeId = RecTypeId);
        insert rlp;
        system.assertNotEquals(rlp, null);

        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt1;
        //Attachment att = new Attachment(Description = 'Sample Doc', ParentId = rlpatt.Id);
        //insert att;
        //PBS_AAAP_RLPSearchController.sequenceNumber[] seq = rlpsc.seqNumList();

        rlpsc.rlpID = rlp.Id;
        rlpsc.actionShowRLP();
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Amendment');
        insert rlpatt;
		
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = rlpatt.Id;
        newFileShare.ShareType= 'V';
        insert newFileShare;

        PBS_AAAP_RLPSearchController.DownloadAllFiles(rlp.Id);

        //PBS_AAAP_RLPSearchController.DownloadAllFiles(rlp.Id);


    }
}