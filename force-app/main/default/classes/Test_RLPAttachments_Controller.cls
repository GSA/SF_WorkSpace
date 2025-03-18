@isTest
private class Test_RLPAttachments_Controller {

    static testMethod void myUnitTest() {
    	// Negative Scenario for throwing an error while inserting the Attachment.
    	Test.startTest();
    	
        PageReference pageRef = Page.PBS_AAAP_RLPAttachments;
        Test.setCurrentPage(pageRef);
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c();
        rlpatt.PBS_AAAP_Attachment_Type__c = 'Standard';
        rlpatt.RLP_Attachment_Name__c = 'Lease Contract (Form L201C)';
        rlpatt.PBS_AAAP_RLP__c = rlp.Id;
        //agency.PBS_AAAP_Region__c = 'National Capital Region';
        insert(rlpatt);
        ApexPages.currentPage().getParameters().put('retURL', '/'+rlp.Id);
    	ApexPages.StandardController s = new ApexPages.StandardController(rlpatt); 
        
       	PBS_AAAP_RLPAttachmentsController rlpcon = new PBS_AAAP_RLPAttachmentsController(s);
       	
       	Attachment att = new Attachment();
       	PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c();
        rlpatt1.PBS_AAAP_Attachment_Type__c = 'Standard';
        rlpatt1.RLP_Attachment_Name__c = 'Lease Contract (Form L201C)';
        rlpatt1.PBS_AAAP_RLP__c = rlp.Id;
        rlpcon.rlpID = rlp.Id;
        
        System.assertEquals(rlpcon.rlpID, rlp.Id);
        
        rlpcon.RLPattachment = rlpatt1;
        rlpcon.att = att;
       	rlpcon.upload();
       	
       	
	    
       	
       	Test.stopTest();
    }	
    static testMethod void myUnitTest1() {  	
       	Test.startTest();
       	// Positive Scenario for inserting the Attachment successfully
       	
       	PageReference pageRef = Page.PBS_AAAP_RLPAttachments;
        Test.setCurrentPage(pageRef);
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        insert rlp;
        
        PBS_AAAP_RLP_Attachments__c rlpatt = new PBS_AAAP_RLP_Attachments__c();
        rlpatt.PBS_AAAP_Attachment_Type__c = 'Standard';
        rlpatt.RLP_Attachment_Name__c = 'Lease Contract (Form L201C)';
        rlpatt.PBS_AAAP_RLP__c = rlp.Id;
        //agency.PBS_AAAP_Region__c = 'National Capital Region';
        insert(rlpatt);
        ApexPages.currentPage().getParameters().put('retURL', '/'+rlp.Id);
    	ApexPages.StandardController s = new ApexPages.StandardController(rlpatt); 
        
       	PBS_AAAP_RLPAttachmentsController rlpcon = new PBS_AAAP_RLPAttachmentsController(s);
       	
       	Blob b = Blob.valueOf('Test Data');        
      
       	Attachment attachment = new Attachment();  
	    //attachment.ParentId = parentId;  
	    attachment.Name = 'Test Attachment for Parent';  
	    attachment.Body = b;
	    
       	PBS_AAAP_RLP_Attachments__c rlpatt1 = new PBS_AAAP_RLP_Attachments__c();
        rlpatt1.PBS_AAAP_Attachment_Type__c = 'Standard';
        rlpatt1.RLP_Attachment_Name__c = 'Lease Contract (Form L201C)';
        rlpatt1.PBS_AAAP_RLP__c = rlp.Id;
        rlpcon.rlpID = rlp.Id;
        
        System.assertEquals(rlpcon.rlpID, rlp.Id);
        
        rlpcon.RLPattachment = rlpatt1;
        rlpcon.att = attachment;
       	rlpcon.upload();
       	
       	
	    
	    
	    
	    Test.stopTest();
    }
}