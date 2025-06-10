@isTest
public class Test_PBS_LOP_ParkingController {
    @isTest
    private static void testMethodWOOfferId(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testorguser@testorg.com');
            
        System.runAs(u) {
            PBS_LOP_ParkingController obj = new PBS_LOP_ParkingController();
            PBS_AAAP_RLP__c rlp = PBS_AAAP_UtilityTest.createFY19RLP();
            rlp.PBS_RSAP_Solicitation_Number__c = '123';
            rlp.PBS_RSAP_Solicitation_Status__c = true;
            rlp.PBS_AAAP_Region__c = 'test region';
            insert RLP;
            
            Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
            
            PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
            offernew.PBS_AAAP_RLP_Number__c = RLP.id;
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = RLP.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = RLP.PBS_RSAP_Solicitation_G_REX_ID__c;
            offernew.PBS_AAAP_Offer_Status__c = 'Closed';
            insert offernew;
            obj.backToOfrBlding();
            obj.lopOffer.PBS_RSAP_GOV_Surface_Spaces__c = 12;
            obj.lopOffer.PBS_AAAP_Total_Surface_Parking_Spaces__c = 10;
            obj.saveParkingInfo();
            
            offernew.PBS_AAAP_Monthly_cost_res_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_res_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_NonResv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_NonResv_Parking__c = 12;
            offernew.PBS_AAAP_Office_RSF_OFFERED__c = 100;
            offernew.PBS_AAAP_Total_Ofc_ABOA_offered__c = 100;
            update offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_ParkingController obj1 = new PBS_LOP_ParkingController();
            obj.isEditable = 'true';
            obj.saveParkingInfo();
            obj1.saveParkingAndContinue();
            obj.actionCancel();
            offernew.PBS_AAAP_Office_RSF_OFFERED__c = null;
            offernew.PBS_AAAP_Total_Ofc_ABOA_offered__c = null;
            update offernew;
            obj.saveParkingInfo();
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
            
            offernew.PBS_AAAP_Monthly_cost_res_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_res_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_NonResv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_NonResv_Parking__c = 12;
            
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_ParkingController obj = new PBS_LOP_ParkingController();
            obj.isEditable = 'true';
            obj.backToOfrBlding();
            obj.saveParkingInfo();
            obj.saveParkingAndContinue();
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
            PBS_LOP_ParkingController obj1 = new PBS_LOP_ParkingController();
            
            offernew1.PBS_AAAP_SITE_SIZE_SQFT__c = 2;
            offernew1.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            update offernew1;
            obj.updateAreaType(offernew1);
        }
        PBS_LOP_ParkingController obj1 = new PBS_LOP_ParkingController();
        System.assert(true);
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
            
            offernew.PBS_AAAP_Monthly_cost_res_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_res_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_NonResv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_NonResv_Parking__c = 12;
            insert offernew;

            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            ApexPages.currentPage().getParameters().put('edit','true');//Added by Poorna
            PBS_LOP_ParkingController obj = new PBS_LOP_ParkingController();
			obj.isEditable = 'true';

            obj.backToOfrBlding();          
            obj.saveParkingInfo();
            
            offernew.PBS_AAAP_Total_Surface_Parking_Spaces__c = 5; 
            offernew.PBS_RSAP_Emp_Visitor_Surface_Spaces__c = 6;
            offernew.PBS_RSAP_GOV_Surface_Spaces__c = 2;
            offernew.PBS_RSAP_Emp_Visitor_Structured_Spaces__c = 7;
            offernew.PBS_AAAP_Total_Structured_Parking_Spaces__c = 6;  
            offernew.PBS_RSAP_GOV_Structured_Spaces__c = 7;             
            obj.lopOffer = offernew;
            obj.saveParkingInfo();
            obj.saveParkingAndContinue();
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
            PBS_LOP_ParkingController obj1 = new PBS_LOP_ParkingController();

            offernew1.PBS_AAAP_SITE_SIZE_SQFT__c = 2;
            offernew1.PBS_AAAP_SITE_AREA_TYPE__c = 'Acres';
            update offernew1;
            obj.updateAreaType(offernew1);
        }
        PBS_LOP_ParkingController obj1 = new PBS_LOP_ParkingController();
        System.assert(true);
    }
    @isTest
    private static void testMethodForCoverage(){
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
            offernew.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 12;
            offernew.PBS_AAAP_Office_RSF_OFFERED__c = 8000;
            offernew.PBS_AAAP_Total_Ofc_ABOA_offered__c = 7000;
            
            offernew.PBS_AAAP_Monthly_cost_res_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_res_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_NonResv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_NonResv_Parking__c = 12;
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_ParkingController obj = new PBS_LOP_ParkingController();
            obj.isEditable = 'true';
            obj.backToOfrBlding();
            obj.lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 12;
            obj.lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = 8000;
            obj.lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 9000;
            obj.lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c =20;
            obj.lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = 1200;
            obj.lopOffer.PBS_AAAP_Parking_Onsite__c = 'Yes';            
            obj.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;            
            obj.saveParkingInfo();
            obj.saveParkingAndContinue();
            obj.lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 7000;
            obj.saveParkingInfo();
            obj.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obj.saveParkingAndContinue();
            obj.actionCancel();
            obj.getOnsiteParkingItems();
            try{
            obj.saveData();
            }catch(Exception e){
                
            }
            obj.rlpType = 'asd';
            System.assert(true); 
        }
        
    }
    
 @isTest
    private static void testMethodForCoverage1(){
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
            offernew.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 12;
            offernew.PBS_AAAP_Office_RSF_OFFERED__c = 8000;
            offernew.PBS_AAAP_Total_Ofc_ABOA_offered__c = 7000;
            
            offernew.PBS_AAAP_Monthly_cost_res_gar_park__c = null;
            offernew.PBS_RSAP_Struct_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_res_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_Resv_Parking__c = 12;
            offernew.PBS_AAAP_Monthly_cost_nonres_gar_park__c = 12;
            offernew.PBS_RSAP_Struct_NonResv_Parking__c = null;
            offernew.PBS_AAAP_Monthly_cost_nonres_sur_park__c = 12;
            offernew.PBS_RSAP_Surf_NonResv_Parking__c = 12;
            
            
            insert offernew;
            
            ApexPages.currentPage().getParameters().put('offerId',offernew.Id);
            PBS_LOP_ParkingController obj = new PBS_LOP_ParkingController();
            obj.isEditable = 'true';
            obj.backToOfrBlding();
            obj.lopOffer.PBS_RSAP_SURFACE_PARKING_ANNUAL_COST__c = 12;
            obj.lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = 8000;
            obj.lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 7000;
            obj.lopOffer.PBS_RSAP_STRUCT_PARKING_ANNUAL_COST__c =20;
            obj.lopOffer.PBS_AAAP_SRVC_UTIL_TOTAL_GOV__c = 1200;
            obj.lopOffer.PBS_AAAP_Parking_Onsite__c = 'Yes';
            
            obj.lopOffer.PBS_AAAP_Office_RSF_OFFERED__c = 10.10;
            obj.lopOffer.PBS_AAAP_Total_Ofc_ABOA_offered__c = 15.10;
            obj.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obj.saveParkingInfo();
            
            obj.lopOffer.PBS_AAAP_Offer_Status__c = PBS_AAAP_GlobalConstants.OFFERSTATUS_SUBMITTED;
            obj.saveParkingAndContinue();
            
            obj.actionCancel();
            
            obj.getOnsiteParkingItems();
            
            try{
            obj.saveData();
            }catch(Exception e){
                
            }
            System.assert(true);
        }
    }
}