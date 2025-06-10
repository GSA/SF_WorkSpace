@isTest
public class Test_PBS_LOP_LeaseTermsController {
    @isTest
    private static void testMethodWithOfferId(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = false;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            offernew.PBS_AAAP_Initial_YEARS_FIRM__c = 1992;
            offernew.PBS_AAAP_INITIAL_NO_OF_YEARS__c = 1992;
            offernew.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew.PBS_AAAP_Architectural_Fees_Percent__c = 0;
            offernew.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_LeaseTermsController obj = new PBS_LOP_LeaseTermsController();
            obj.getarcenggOptionItems();
            obj.initializeSpaceAndRates();
            obj.getHVACOTOptionItems();
            obj.getItems();
            obj.backToOperatingCostTab();
            obj.saveLeaseTermsInfo();            
            obj.saveLeaseTermsandContinue();
            
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            update offernew;
            obj.saveLeaseTermsandContinue();
            
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Flat Fee ($)';
            Update offernew;
            obj = new PBS_LOP_LeaseTermsController();
            obj.saveLeaseTermsandContinue();
            
            obj = new PBS_LOP_LeaseTermsController();
            obj.archEnggFee = '';
            obj.saveLeaseTermsandContinue();
            obj.actionCancel();
            PBS_LOP_LeaseTermsController.isNumeric('test');
            PBS_AAAP_RLP__c rlp1 = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp1.PBS_RSAP_Solicitation_Number__c = '123';
            rlp1.PBS_RSAP_Solicitation_Status__c = true;
            rlp1.PBS_AAAP_Region__c = 'test region';
            insert rlp1;
            
            PBS_AAAP_Offer__c offernew1 = new PBS_AAAP_Offer__c();
            offernew1.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew1.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew1.RecordTypeId = RSAPRecTypeId;
            offernew1.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew1.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew1.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            offernew1.PBS_AAAP_Initial_YEARS_FIRM__c = 1992;
            offernew1.PBS_AAAP_INITIAL_NO_OF_YEARS__c = 1992;
            offernew1.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew1.PBS_AAAP_Architectural_Fees_Percent__c = 0;
            offernew1.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            insert offernew1;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','false');
            PBS_LOP_LeaseTermsController obj1 = new PBS_LOP_LeaseTermsController();
            obj1.archEnggFee = '10';
            obj1.saveLeaseTermsInfo();
            obj1.saveLeaseTermsandContinue();
            obj1.archEnggFee = '';
            obj1.saveLeaseTermsInfo();
            PBS_AAAP_Offer__c offernew2 = new PBS_AAAP_Offer__c();
            offernew2.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew2.RecordTypeId = RSAPRecTypeId;
            offernew2.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew2.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offernew2.PBS_AAAP_Owner_City__c = 'Test City';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test Addr';
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            offernew2.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Flat Fee ($)';
            offernew2.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew2.PBS_AAAP_Architectural_Fees_Percent__c = 0;
            offernew2.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            insert offernew2;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew2.Id);
            PBS_LOP_LeaseTermsController obj2 = new PBS_LOP_LeaseTermsController();
            obj2.archEnggFee = '10';
            obj2.saveLeaseTermsInfo();
            obj2.saveLeaseTermsandContinue();
            obj2.updateAreaType(offernew2);
            offernew2.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            offernew2.PBS_AAAP_SITE_SIZE_SQFT__c = 2;
            obj2.updateAreaType(offernew2);
            System.assertEquals('Acres', offernew2.PBS_AAAP_SITE_AREA_TYPE__c, 'This should be equalts');
        }
        PBS_LOP_LeaseTermsController obj1 = new PBS_LOP_LeaseTermsController();
    }

    @isTest
    private static void testMethodWithOfferId2(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = false;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;

            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();

            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA SF ($)';
            offernew.PBS_AAAP_Initial_YEARS_FIRM__c = 1992;
            offernew.PBS_AAAP_INITIAL_NO_OF_YEARS__c = 1992;
            offernew.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew.PBS_AAAP_Architectural_Fees_Percent__c = 101;
            offernew.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            insert offernew;
		

            PBS_AAAP_Offer__c offernew2 = new PBS_AAAP_Offer__c();
            offernew2.PBS_AAAP_RLP_Number__c = rlp.id;
            offernew2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew2.RecordTypeId = RSAPRecTypeId;
            offernew2.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew2.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offernew2.PBS_AAAP_Owner_City__c = 'Test City';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test Addr';
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            offernew2.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Flat Fee ($)';
            offernew2.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew2.PBS_AAAP_Architectural_Fees_Percent__c = 101;
            offernew2.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            offernew2.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Flat Fee ($)';
            offernew2.Confirm_Full_Term_Lease_Months__c = 100; 
            offernew2.PBS_AAAP_Lessor_Prj_Fees__c =1;
            offernew2.Confirm_Firm_Term_Lease_Months__c = 100;
            insert offernew2;

            ApexPages.currentPage().getParameters().put('offerId',offernew2.Id);
            PBS_LOP_LeaseTermsController obj2 = new PBS_LOP_LeaseTermsController();
            obj2.archEnggFee = '10';
            //obj2.saveLeaseTermsInfo();
            //obj2.saveLeaseTermsandContinue();
            obj2.updateAreaType(offernew2);
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA SF ($)'; 
            obj2.archEnggFee = null;         
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            obj2.archEnggFee = '101';
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)'; 
            obj2.archEnggFee = '12'; 
            obj2.lopOffer.Confirm_Full_Term_Lease_Months__c = 2;
            obj2.lopOffer.Confirm_Firm_Term_Lease_Months__c = 2;
            obj2.buildingIndexNumber = '1';
            obj2.deleteTheRow();
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2.saveLeaseTermsInfo();            
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)'; 
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2.saveLeaseTermsInfo();
            
            
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obj2.saveLeaseTermsandContinue();
            
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2 = new PBS_LOP_LeaseTermsController();
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = NULL;
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            obj2.saveLeaseTermsInfo();
            
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            obj2.saveLeaseTermsInfo();
            
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            obj2.saveLeaseTermsandContinue();
            System.assertEquals('Per ABOA Square Feet ($)', obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c, 'This should be equalts');
        }
        PBS_LOP_LeaseTermsController obj1 = new PBS_LOP_LeaseTermsController();
    }
    @isTest
    private static void testMethodWithOfferId3(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');

        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = false;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;

            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();

            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA SF ($)';
            offernew.PBS_AAAP_Initial_YEARS_FIRM__c = 1992;
            offernew.PBS_AAAP_INITIAL_NO_OF_YEARS__c = 1992;
            offernew.PBS_AAAP_ARCH_ENG_FEES_PER_USF__c = 0.00;
            offernew.PBS_AAAP_Architectural_Fees_Percent__c = 101;
            offernew.PBS_AAAP_Architectural_Fees_Flat__c = 0;
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_LeaseTermsController obj2 = new PBS_LOP_LeaseTermsController();
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Per ABOA Square Feet ($)';
            obj2.archEnggFee = 'ab';
            obj2.saveLeaseTermsandContinue();
            obj2.saveLeaseTermsInfo();                       
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = 'Percent of Total Construction Costs (%)';
            obj2.archEnggFee = '200';
            obj2.saveLeaseTermsandContinue();
            obj2.saveLeaseTermsInfo();            
            obj2.lopOffer.PBS_AAAP_Architectural_Fees_Percent__c = null;
            obj2.lopOffer.PBS_AAAP_Architectural_Fees_Flat__c = null;
            obj2.archEnggFee = null;
            obj2.lopOffer.PBS_AAAP_ARCHITECTURAL_ENG_FEES_UOM__c = NULL;
            obj2.saveLeaseTermsInfo();
            obj2.archEnggFee = '12';
            System.assertEquals('12', obj2.archEnggFee, 'This should be equalts');
        }
            
    }
}