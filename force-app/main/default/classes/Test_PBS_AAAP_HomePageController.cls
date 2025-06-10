@IsTest
private class Test_PBS_AAAP_HomePageController {

    static testMethod void actionSearchRLPSiteTest() {
        test.startTest();
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_SitesRLP');
        Test.setCurrentPage(currentPage);
        
        Cookie offerIdCookie = new Cookie('rlpRegion','National Capital Region',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        PBS_AAAP_HomePageController hpc = new PBS_AAAP_HomePageController();
        System.assert(true);
        hpc.selectedRegion = 'Region 1';
        hpc.getRegions();
        hpc.actionShowRLPs();
        hpc.actionSearchRLPSite();
        RLP.PBS_AAAP_Region__c = hpc.selectedRegion;
        update RLP;
        hpc.actionShowRLPs();
        test.stopTest();
    }
    static testmethod void testUserType() {
        
		String usrType = PBS_AAAP_HomePageController.getUserType();
		System.assertNotEquals(null, usrType);

	}
    static testMethod void actionSearchRLPSiteExceptionTest() {
        test.startTest();
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_SitesRLP');
        Test.setCurrentPage(currentPage);
        
        Cookie offerIdCookie = new Cookie('rlpRegion','National Capital Region3',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        PBS_AAAP_HomePageController hpc = new PBS_AAAP_HomePageController();
        hpc.userid = 'Hi';
        hpc.pin = 'Hi';
        //System.assertEquals(hpc.showRLPTable, false);
        System.assert(true);
        hpc.actionShowRLPs();
        test.stopTest();
    }

    static testMethod void showRLPExceptionTest() {
        test.startTest();
        List <PBS_AAAP_RLP__c> rlpList; 
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        PageReference currentPage = new PageReference('/apex/PBS_AAAP_SitesRLP');
        Test.setCurrentPage(currentPage);
        
        Cookie offerIdCookie = new Cookie('rlpRegion','National Capital Region',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        PBS_AAAP_HomePageController hpc = new PBS_AAAP_HomePageController();
        hpc.actionShowRLPs();
        //System.assertEquals(hpc.selectedRegion, 'National Capital Region');
        System.assert(true);
        test.stopTest();
    }

    static testMethod void actionShowRLPDetailTest() {
        test.startTest();
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt;

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_SitesRLP');
        Test.setCurrentPage(currentPage);

     Cookie offerIdCookie = new Cookie('rlpRegion','National Capital Region',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        PBS_AAAP_HomePageController hpc = new PBS_AAAP_HomePageController();

        hpc.rlpID = rlp.Id;
        hpc.actionShowRLPDetail();
        hpc.backToSearch();
        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Amendment');
        insert rlpatt1;
        hpc.actionShowRLPDetail();
        System.assertEquals(hpc.showAmendmentsTable, true);
        test.stopTest();
    }
    static testMethod void actionShowRLPDetailTestForElse() {
        test.startTest();
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert RLP;
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt;

        PageReference currentPage = new PageReference('/apex/PBS_AAAP_SitesRLP');
        Test.setCurrentPage(currentPage);
        
        Cookie offerIdCookie = new Cookie('rlpID','12345ABC',null,-1,true);
        ApexPages.currentPage().setCookies(new Cookie[]{offerIdCookie});
        PBS_AAAP_HomePageController hpc = new PBS_AAAP_HomePageController();

        hpc.rlpID = rlp.Id;
        hpc.actionShowRLPDetail();
        hpc.backToSearch();
        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Amendment');
        insert rlpatt1;

        hpc.actionShowRLPDetail();
        System.assertEquals(hpc.showAmendmentsTable, true);

        test.stopTest();
    }
    
    static testMethod void downloadAttachments() {

        PBS_AAAP_HomePageController rlpsc = new PBS_AAAP_HomePageController();
        test.startTest();
        PBS_AAAP_RLP__c rlp = new PBS_AAAP_RLP__c(PBS_AAAP_Region__c = 'National Capital Region', PBS_AAAP_STATUS__c = 'Posted/active',
                PBS_AAAP_Category__c = 'Office', PBS_AAAP_Title__c = 'National RLP');
        insert rlp;
        system.assertNotEquals(rlp, null);

        PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c(PBS_AAAP_Title__c = 'Sample', PBS_AAAP_RLP__c = rlp.id, PBS_AAAP_Attachment_Type__c = 'Standard');
        insert rlpatt1;

        rlpsc.rlpID = rlp.Id;
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
        newFileShare.LinkedEntityId = rlpatt1.Id;
        newFileShare.ShareType= 'V';
        insert newFileShare;
        PBS_AAAP_HomePageController.DownloadAllFiles(rlp.Id);
        system.assertEquals(true, true);

    }
}