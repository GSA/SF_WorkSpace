/**
 * Created by nkopparthi on 5/20/19.
 */

public with sharing class PBS_LOP_OfferLandingController {

    public boolean isValidUser { get; set; }
    public PBS_AAAP_Offer__c lopOffer { get; set; }
    public String draftMsgFlag { get; set; }
    public String solicitationId { get; set; }
    public User userDetail { get; set; }
    public String offerId { get; set; }
    public String rlpRSAPRecordType {get; set;}
    public boolean displayPopup {get; set;}
    public boolean noSolicitation {get; set;}
    public boolean wrongSolicitaion {get; set;}
    public boolean showConfirmation {get; set;}
    public string city {get; set;}
    public string state {get; set;}
    public String pageURLForRedirection{get;set;}  //Lekha 3/6/2023  SFWS-2403


    public PBS_LOP_OfferLandingController() {
        userDetail = [SELECT u.Username, u.ProfileId,u.CompanyName, u.Name, u.Id, u.ContactId, u.LastName, u.FirstName, u.Street, u.City, u.State, u.PostalCode FROM User u WHERE u.Id = :UserInfo.getUserId()];
        offerId = ApexPages.currentPage().getParameters().get('offerId');
        draftMsgFlag = ApexPages.currentPage().getParameters().get('draftMsgFlag');
        isValidUser = TRUE;

        rlpRSAPRecordType = Schema.SObjectType.PBS_AAAP_RLP__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();
    }

    public void createEditOffer() {
        system.debug('Create / Edit Offer : Project ');
        system.debug('Create / Edit Offer : : Project ID project.Project_Number__c');
        system.debug('Create / Edit Offer : : EOI project.Project_EOI_ID__c');
        string newOfferID = '';
        PBS_AAAP_RLP__c grexProject = new PBS_AAAP_RLP__c();


        try {
            grexProject = [
                    SELECT Id,
                            Name,
                            PBS_RSAP_Solicitation_Number__c,
                            PBS_RSAP_Solicitation_G_REX_ID__c
                    FROM PBS_AAAP_RLP__c
                    WHERE PBS_RSAP_Solicitation_Number__c = :solicitationId
                    AND PBS_RSAP_Solicitation_Status__c = TRUE
                    AND RecordTypeId = :rlpRSAPRecordType
            ];
            System.debug('grexProject is - ' + grexProject);
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Solicitation Number is incorrect or the window for offering submissions has expired.  Please try again or contact RSAP.Manager@gsa.gov for more assistance.');
            ApexPages.addMessage(myMsg);
            
        }


        system.debug('Create / Edit Offer : Tempworkclass_VSS: EOI project.name' + grexProject.Id);
        List<PBS_AAAP_Offer__c> offer1 = new List<PBS_AAAP_Offer__c>();
        PBS_AAAP_Offer__c offernew = new PBS_AAAP_Offer__c();
        Id RSAPRecTypeId = Schema.SObjectType.PBS_AAAP_Offer__c.getRecordTypeInfosByName().get('RSAP').getRecordTypeId();

        offer1 = [SELECT Id FROM PBS_AAAP_Offer__c WHERE PBS_AAAP_RLP_Number__c = :grexProject.Id AND CreatedById = :userDetail.id];
        system.debug('Create / Edit Offer : Tempworkclass_VSS: I am here' + offer1.size());
        PageReference p;
        if (offer1.size() == 0) {
            offernew.PBS_AAAP_RLP_Number__c = grexProject.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = grexProject.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = grexProject.PBS_RSAP_Solicitation_G_REX_ID__c;
            insert offernew;
            newOfferID = offernew.id;
            system.debug('Create / Edit Offer : Tempworkclass_VSS: Offer1' + offer1);
            p = Page.PBS_LOP_Building;
            p.getParameters().put('offerId', newOfferID);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/apex/pbs_lop_building', Label.LOP_Community_Base_URL+'Offer-S-Eligibility');
            System.debug('*****'+pageURLForRedirection);
            p.setRedirect(true);
            displayPopUp = false;
          
        } else {
            
            offernew.PBS_AAAP_RLP_Number__c = grexProject.id;
            offernew.PBS_AAAP_Offer_Status__c = 'Draft';
            offernew.RecordTypeId = RSAPRecTypeId;
            offernew.PBS_AAAP_Solicitation_Number__c = grexProject.PBS_RSAP_Solicitation_Number__c;
            offernew.PBS_AAAP_Solicitation_Id__c = grexProject.PBS_RSAP_Solicitation_G_REX_ID__c;
            insert offernew;
            newOfferID = offernew.id;
            system.debug('Create / Edit Offer : Tempworkclass_VSS: Offer1' + offer1);
             p = Page.pbs_lop_building;
           
            p.getParameters().put('offerId', newOfferID);
            pageURLForRedirection = p.getUrl();
            pageURLForRedirection = pageURLForRedirection.replace('/apex/pbs_lop_building', Label.LOP_Community_Base_URL+'Offer-S-Eligibility');
            System.debug('*****'+pageURLForRedirection);
            p.setRedirect(true);
            displayPopUp = false;
        
        }


    }

    public void closePopup() {
        displayPopup = false;
    }

    public pageReference showPopup() {

        PBS_AAAP_RLP__c grexProject1 = new PBS_AAAP_RLP__c();

        try {
            grexProject1 = [
                    SELECT Id,
                            Name,
                            PBS_RSAP_Solicitation_Number__c,
                            PBS_RSAP_Solicitation_G_REX_ID__c
                    FROM PBS_AAAP_RLP__c
                    WHERE PBS_RSAP_Solicitation_Number__c = :solicitationId
                    AND PBS_RSAP_Solicitation_Status__c = TRUE
                    AND RecordTypeId = :rlpRSAPRecordType
            ];
            
        } catch (Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Solicitation number is incorrect or the window for submitting an offer has expired. See below for additional guidance.');
            ApexPages.addMessage(myMsg);
            return ApexPages.currentPage();
        }


        displayPopup = true;
        if(solicitationId == NULL || solicitationId == ''){
            noSolicitation = TRUE;
            wrongSolicitaion = FALSE;
            showConfirmation = FALSE;
        } else {
            try {
                PBS_AAAP_RLP__c grexProject = new PBS_AAAP_RLP__c();
                grexProject = [
                        SELECT Id,
                                Name,
                                PBS_RSAP_City__c,
                                PBS_RSAP_State__c,
                                PBS_RSAP_Solicitation_Number__c,
                                PBS_RSAP_Solicitation_G_REX_ID__c
                        FROM PBS_AAAP_RLP__c
                        WHERE PBS_RSAP_Solicitation_Number__c = :solicitationId
                        AND PBS_RSAP_Solicitation_Status__c = TRUE
                        AND RecordTypeId = :rlpRSAPRecordType
                ];
                System.debug('grexProject is - ' + grexProject);

                city = grexProject.PBS_RSAP_City__c;
                state = grexProject.PBS_RSAP_State__c;
                showConfirmation = TRUE;
                noSolicitation = FALSE;
                wrongSolicitaion = FALSE;

            } catch (Exception ex) {
                wrongSolicitaion = TRUE;
                showConfirmation = FALSE;
                noSolicitation = FALSE;
            }


        }

        return null;
    }

}