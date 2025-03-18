@isTest
private class Test_PBS_AAAP_ImageCntrl {

    @testSetup static void createData() {
        
        string Folderid = [SELECT ID 
                                FROM Folder 
                                WHERE NAME = 'AAAP Folder'].Id;
        
        Document document = new Document();
        document.Body = Blob.valueOf('Some Text');
        document.ContentType = 'application/pdf';
        document.DeveloperName = 'my_document';
        document.IsPublic = true;
        document.Name = 'My Document';
        document.FolderId = Folderid;
        insert document;
        
        PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createRLP();
        //added by syam on 08/10/2016
        rlp.PBS_AAAP_DISCOUNT_RATE__c = 12.00;
        rlp.PBS_AAAP_ESCALATION_RATE_PERCENT__c = 12.00;
        //rlp.PBS_AAAP_Year__c = '2019';
        insert rlp;
        System.debug('rlp is ****' + rlp);
        PBS_AAAP_Property__c prop = new PBS_AAAP_Property__c();
        prop.PBS_AAAP_MetroWalkable__c = true;
        prop.PBS_AAAP_X_CO_ORD__c = -77.00896157;
        prop.PBS_AAAP_Y_CO_ORD__c = 38.90251766;
        insert prop;

        PBS_AAAP_Offer__c offer = PBS_AAAP_UtilityTest.createOfferInfo();
        offer.PBS_AAAP_RLP_Number__c = rlp.Id;
        offer.PBS_AAAP_Offer_Status__c = 'Submitted';
        offer.PBS_AAAP_Total_Parking_Spaces__c = 100;
        offer.PBS_AAAP_Is_Offer_Valid__c = true;
        offer.Property__c = prop.Id;
        insert offer;
        
    }
    
    static testMethod void validate_ImageCntrl() {
    
        PBS_AAAP_Offer__c offer  = [select id from PBS_AAAP_Offer__c limit 1];
        Apexpages.StandardController sc = new Apexpages.StandardController(offer);
        PBS_AAAP_ImageCntrl obj = new PBS_AAAP_ImageCntrl();
        PBS_AAAP_ImageCntrl ext = new  PBS_AAAP_ImageCntrl(sc);        
        ext.fetchDocument();
        ext.deleteImage();
        ext.strImagename = 'test';
        ext.strImageBlob = 'abd';
        ext.captureImage();
        
    }
    
}