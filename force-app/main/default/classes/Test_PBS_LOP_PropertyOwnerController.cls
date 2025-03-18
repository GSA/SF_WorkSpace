@isTest
public class Test_PBS_LOP_PropertyOwnerController {
    @isTest
    private static void testMethodWOOfferId(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = 'Other';
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_PropertyOwnerController obj = new PBS_LOP_PropertyOwnerController();
            obj.sameOwner = TRUE;
            obj.copyUserDetails();
            obj.showOfferorRelationShipOther();
            obj.getOtherRelationShip();
            obj.backToOfrParking();
            obj.actionSavePropertyOwner();
            obj.actionSavePropertyOwner2();
            obj.actionSavePropertyOwnerAndContinue();
            obj.actionCancel();
            //obj.updateAreaType(offernew);
            System.assert(true);
        }
    }
    
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
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_PropertyOwnerController obj = new PBS_LOP_PropertyOwnerController();
            obj.copyUserDetails();
            obj.showOfferorRelationShipOther();
            obj.getOtherRelationShip();
            obj.backToOfrParking();
            obj.actionSavePropertyOwner();
            obj.actionSavePropertyOwner2();
            obj.actionSavePropertyOwnerAndContinue();
            obj.actionCancel();
            
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
            insert offernew1;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','false');
            PBS_LOP_PropertyOwnerController obj1 = new PBS_LOP_PropertyOwnerController();
            obj1.copyUserDetails();
            obj1.showOfferorRelationShipOther();
            obj1.getOtherRelationShip();
            obj1.backToOfrParking();
            obj1.actionSavePropertyOwner();
            obj1.actionSavePropertyOwner2();
            obj1.actionSavePropertyOwnerAndContinue();

            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','true');
            PBS_LOP_PropertyOwnerController obj3 = new PBS_LOP_PropertyOwnerController();
            obj3.copyUserDetails();
            obj3.showOfferorRelationShipOther();
            obj3.getOtherRelationShip();
            obj3.backToOfrParking();
            obj3.actionSavePropertyOwner();
            obj3.actionSavePropertyOwner2();
            obj3.actionSavePropertyOwnerAndContinue();
            
            PBS_AAAP_Offer__c offernew2 = new PBS_AAAP_Offer__c();
            offernew2.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew2.RecordTypeId = RSAPRecTypeId;
            offernew2.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew2.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offernew2.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = '';
            offernew2.PBS_AAAP_Owner_City__c = 'Test City';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test Addr';
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            insert offernew2;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew2.Id);
            PBS_LOP_PropertyOwnerController obj2 = new PBS_LOP_PropertyOwnerController();
            obj2.copyUserDetails();
            obj2.showOfferorRelationShipOther();
            obj2.getOtherRelationShip();
            obj2.backToOfrParking();
            obj2.actionSavePropertyOwner();
            obj2.actionSavePropertyOwner2();
            obj2.actionSavePropertyOwnerAndContinue();
            
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test';
            offernew2.PBS_AAAP_Owner_City__c = 'Test';
            offernew2.PBS_AAAP_Owner_State__c = 'Test';
            offernew2.PBS_AAAP_Owner_Zip__c = 'Test';
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';           
            update offernew2;
            obj2.lopOffer = offernew2;
            obj2.copyUserDetails();
            obj2.showOfferorRelationShipOther();
            obj2.getOtherRelationShip();
            obj2.backToOfrParking();
            obj2.actionSavePropertyOwner();
            obj2.actionSavePropertyOwner2();
            obj2.actionSavePropertyOwnerAndContinue();
            System.assert(true);
        }
        PBS_LOP_PropertyOwnerController obj1 = new PBS_LOP_PropertyOwnerController();
    }
    
    @isTest
    private static void testMethodWithOutOfferId(){
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
            insert offernew;
            
            //ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_PropertyOwnerController obj = new PBS_LOP_PropertyOwnerController();
            /**
            obj.copyUserDetails();
            obj.showOfferorRelationShipOther();
            obj.getOtherRelationShip();
            obj.backToOfrParking();
            obj.actionSavePropertyOwner();
            obj.actionSavePropertyOwner2();
            obj.actionSavePropertyOwnerAndContinue();
            obj.actionCancel();
            **/
            
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
            insert offernew1;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','false');
            PBS_LOP_PropertyOwnerController obj1 = new PBS_LOP_PropertyOwnerController();
            obj1.copyUserDetails();
            obj1.showOfferorRelationShipOther();
            obj1.getOtherRelationShip();
            obj1.backToOfrParking();
            obj1.actionSavePropertyOwner();
            obj1.actionSavePropertyOwner2();
            obj1.actionSavePropertyOwnerAndContinue();

            ApexPages.currentPage().getParameters().put('offerId',offernew1.Id);
            ApexPages.currentPage().getParameters().put('edit','true');
            PBS_LOP_PropertyOwnerController obj3 = new PBS_LOP_PropertyOwnerController();
            obj3.copyUserDetails();
            obj3.showOfferorRelationShipOther();
            obj3.getOtherRelationShip();
            obj3.backToOfrParking();
            obj3.actionSavePropertyOwner();
            obj3.actionSavePropertyOwner2();
            obj3.actionSavePropertyOwnerAndContinue();
            
            PBS_AAAP_Offer__c offernew2 = new PBS_AAAP_Offer__c();
            offernew2.PBS_AAAP_RLP_Number__c = rlp1.id;
            offernew2.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            offernew2.RecordTypeId = RSAPRecTypeId;
            offernew2.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew2.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Other';
            offernew2.PBS_AAAP_OFFEROR_INTEREST_OTHER__c = '';
            offernew2.PBS_AAAP_Owner_City__c = 'Test City';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test Addr';
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            insert offernew2;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew2.Id);
            PBS_LOP_PropertyOwnerController obj2 = new PBS_LOP_PropertyOwnerController();
            obj2.copyUserDetails();
            obj2.showOfferorRelationShipOther();
            obj2.getOtherRelationShip();
            obj2.backToOfrParking();
            obj2.actionSavePropertyOwner();
            obj2.actionSavePropertyOwner2();
            obj2.actionSavePropertyOwnerAndContinue();
            
            offernew2.PBS_AAAP_Owner_Name__c = 'Test';
            offernew2.PBS_AAAP_Owner_Address__c = 'Test';
            offernew2.PBS_AAAP_Owner_City__c = 'Test';
            offernew2.PBS_AAAP_Owner_State__c = 'Test';
            offernew2.PBS_AAAP_Owner_Zip__c = 'Test';
            offernew2.PBS_AAAP_OFFEROR_INTEREST__c = 'Agent';     
            offernew2.PBS_AAAP_DUNS_Number__c = '4345425';      
            update offernew2;
            obj2.lopOffer = offernew2;
            obj2.copyUserDetails();
            obj2.showOfferorRelationShipOther();
            obj2.getOtherRelationShip();
            obj2.backToOfrParking();
            obj2.actionSavePropertyOwner();
            obj2.actionSavePropertyOwner2();
            obj2.actionSavePropertyOwnerAndContinue();
            System.assert(true);
        }

        
        //PBS_LOP_PropertyOwnerController obj1 = new PBS_LOP_PropertyOwnerController();
    }
}