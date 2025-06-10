import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getOffer from '@salesforce/apex/PBS_Leasing_OfferOptionsController.getOffer';
import deleteOffer from '@salesforce/apex/PBS_Leasing_OfferOptionsController.deleteOffer';
import actionLopOfferEdit from '@salesforce/apex/PBS_Leasing_OfferOptionsController.actionLopOfferEdit';
import actionOfferEdit from '@salesforce/apex/PBS_Leasing_OfferOptionsController.actionOfferEdit';

export default class PBS_LeasingOfferOptions extends NavigationMixin( LightningElement ) {

    @api offerId = '';
    errors = '';
    error =[];
    selectedOption = '';

    @track offerDetails = {};
    @track offerType = '';
    @track solicitationNumber = '';
    @track solicitationStatus = '';
    @track isError = '';
    offerDetailsError = '';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;
            this.isError = currentPageReference.state.isError;
        }
    }

    connectedCallback() {
        console.log('Starting connectedCallback(), this.propertyId = ' + this.propertyId + ', this.offerId = ' + this.offerId);
        if (this.offerId) {
	    console.log('about to call getOfferDetails()...');
            getOffer({ offerId: this.offerId })
            .then(result => {
                console.log('result ' + JSON.stringify(result));
                if (result.isSuccess === true) {
                    this.offerDetails = result.offer;
                    this.offerType = this.offerDetails.RecordType.Name;
                    this.solicitationNumber = this.offerDetails.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c;
                    this.solicitationStatus = this.offerDetails.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Status__c;
                } else {
                    // Handle error
                    console.log('error: ' + JSON.stringify(error));
                    this.offerDetailsError = result.errorMessages;
                    alert('There was an issue retrieving the Offer.  Please notify your system adminitrator for assistance.');
                }
            })
            .catch(error => {
                // Handle error
                console.log('error: ' + JSON.stringify(error));
                this.offerDetailsError = JSON.stringify(error);
                alert('There was an issue retrieving the Offer.  Please notify your system adminitrator for assistance.');
            });
        } else {
            console.log('Missing offerId.');
            alert('There was an issue retrieving the Offer.  Please notify your system adminitrator for assistance.');
        }
        
    }
    handleOptionOne() {
        this.selectedOption = '1';  
    } 
    handleOptionTwo() {  
        this.selectedOption = '2';  
    }
    handleOptionThree() {  
        this.selectedOption = '3';  
    }
    handleOptionFour() {  
        this.selectedOption = '4';
    }
    handleSelect() {
        if (this.offerId) {
            if (this.selectedOption == '1') {
                //only forward to Eligibility page if there is a property associated to this offer, otherwise go to Property Location page to create one
                if (this.propertyId && this.propertyId != 'undefined') {
                    if(this.offerType == 'AAAP'){
                       //window.location.href = '/leasing/s/Offer-M-Eligibility?edit=true&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                       actionOfferEdit({ offerId: this.offerId,propertyId:this.propertyId })
                       .then(result => {
                            console.log('actionOfferEdit sucess ',result);
                            if(result === 'pmError')
                            {
                                this.errors = [];
                                const scrollOptions = {
                                    left: 0,
                                    top: 0,
                                    behavior: 'smooth'
                                }
                                window.scrollTo(scrollOptions);
                                this.errors[0] = 'You have already begun editing this offer during a closed period. Please edit the offer currently in Pending Modification status to update your offer details';
                            }
                            else{
                            window.location.href = result;
                            }
                       })
                       .catch(error => {
                           // Handle error
                           console.log('error: ' + JSON.stringify(error));
                       });

                       /*if(this.isError){
                        alert('You have already begun editing this offer during a closed period. Please edit the offer currently in Pending Modification status to update your offer details');
                    }*/
                    }else{
                        //window.location.href = '/leasing/s/Offer-S-Eligibility?edit=true&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                        console.log('actionLopOfferEdit');
                        actionLopOfferEdit({ offerId: this.offerId,propertyId:this.propertyId })
                        .then(result => {
                             console.log('actionLopOfferEdit sucess ',result);
                             window.location.href = result;
                        })
                        .catch(error => {
                            // Handle error
                            console.log('error: ' + JSON.stringify(error));
                        });
                    }
                }else{
                    window.location.href = '/leasing/s/Offer-Location?offerId=' + this.offerId;
                }
            } else if (this.selectedOption == '2') {
                if(this.offerType == 'AAAP'){
                    window.location.href = '/leasing/s/Offer-M-AdditionalAttachments?offerId=' + this.offerId+'&propertyId='+this.propertyId;
                }else{
                    window.location.href = '/leasing/s/Offer-S-AdditionalAttachments?offerId=' + this.offerId+'&propertyId='+this.propertyId;
                }
            }else if (this.selectedOption == '3') {
                if(this.offerType == 'AAAP'){
                    if (this.propertyId && this.propertyId != 'undefined') {
                        window.location.href = '/leasing/s/Offer-M-Eligibility?edit=false&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                      }
                      else if(this.offerId)
                      {
                        window.location.href = '/leasing/s/Offer-M-Eligibility?edit=false&offerId=' + this.offerId;
                      }

                    }else{
                        if (this.propertyId && this.propertyId != 'undefined') {
                    window.location.href = '/leasing/s/Offer-S-Eligibility?edit=false&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                        }
                        else if(this.offerId)
                            {
                              window.location.href = '/leasing/s/Offer-S-Eligibility?edit=false&offerId=' + this.offerId;
                            }
                }
            } else if (this.selectedOption == '4') {
                if (confirm('Are you sure you want to delete this offer from the system?  Click OK to delete.  Otherwise click Cancel.')) {
                    this.deleteOfferInfo();
                }
            } else {
                alert('Please select an option and then click Select.');
            }
        } else {
            console.error('offerId is not provided');
        }
    }
    handleBack() {
        window.location.href = '/leasing/s/Offer-Home';
    }    
    deleteOfferInfo() {
        this.errors = [];
        console.log('about to call PBS_LeasingEditOfferOptions deleteOffer() for offerId ' + this.offerId + '...');
        deleteOffer({ offerId: this.offerId })
            .then((response) => {
                console.log('response ', response);
                if (response.isSuccess === true) {
                    console.log('successful call');
                    alert('The Offer and related data has been successfully deleted. Redirecting to Offer-Home page.');
                    window.location.href = '/leasing/s/Offer-Home';
                } else {
                    console.log('unsuccessful call');
                    const scrollOptions = {
                        left: 0,
                        top: 0,
                        behavior: 'smooth'
                    }
                    window.scrollTo(scrollOptions);
                    this.errors = response.errorMessages;
                }
            })
            .catch(error => {
                console.error('Error deleting offer', error);
            });
    }  
    get offerPropertyName(){
        return this.offerDetails.PBS_AAAP_Building_Name__c;
    }
    get rlpOrSolicitationLabel() {
        if (this.offerType == 'AAAP') {
            return 'RLP Number';
        } else {
            return 'RLP Number';
        }
    }
    get rlpOrSolicitationValue() {
        if (this.offerType == 'AAAP') {
            return this.offerDetails.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
        } else {
            return this.solicitationNumber;
        }
    }
    get offerStatus(){
        return this.offerDetails.PBS_AAAP_Offer_Status__c;
    }
    get editOfferDivClass(){
        //hide the "edit offer" option if there were Offer Details retrieval errors or incorrect AAAP or RSAP status
        return (this.offerDetailsError.length > 0 ||
               ((this.offerType == 'AAAP' && (this.offerDetails.PBS_AAAP_Offer_Status__c == 'Pending Review' || (this.offerDetails.PBS_AAAP_Offer_Status__c == 'Awarded/Pending Review' && this.offerDetails.PBS_AAAP_RLP_Number__r.PBS_AAAP_Status__c != 'Posted/Active' && this.offerDetails.PBS_AAAP_Total_Withdraw_Space__c <= 0))) ||
                (this.offerType == 'RSAP' && (this.solicitationStatus == false || (this.offerDetails.PBS_AAAP_Offer_Status__c != 'Draft' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted')))))
               ? 'hideEditOfferOption' : 'slds-grid';
    }
    get addViewDocDivClass(){
        //hide the "add / view documentation" option if there were Offer Details retrieval errors or incorrect AAAP or RSAP status
        return (this.offerDetailsError.length > 0 ||
               ((this.offerType == 'AAAP' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Pending Review' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Awarded/Pending Review' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Awarded/Submitted') ||
                (this.offerType == 'RSAP' && (this.solicitationStatus == false || this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted'))))
               ? 'hideAddViewDocOption' : 'slds-grid';
    }
    get viewOfferDivClass(){
        //hide the "view offer" option if there were Offer Details retrieval errors or incorrect AAAP status
        return (this.offerDetailsError.length > 0 ||
               (this.offerType == 'AAAP' && this.offerDetails.PBS_AAAP_Offer_Status__c == null/*'Pending Review' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Awarded'*/) ||
               (this.offerType == 'RSAP' && (this.offerDetails.PBS_AAAP_Offer_Status__c != 'Closed' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Draft' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Withdrawn')))
               ? 'hideViewOfferOption' : 'slds-grid';
    }
    get deleteOfferDivClass(){
        //hide the "delete my offer" option if there were Offer Details retrieval errors or incorrect AAAP or RSAP status
        return (this.offerDetailsError.length > 0 ||
               ((this.offerType == 'AAAP' && this.offerDetails.PBS_AAAP_Offer_Status__c == 'Pending Review' || this.offerDetails.PBS_AAAP_Offer_Status__c == 'Awarded/Pending Review') ||
                (this.offerType == 'RSAP' && (this.solicitationStatus == false || (this.offerDetails.PBS_AAAP_Offer_Status__c != 'Draft' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Submitted' && this.offerDetails.PBS_AAAP_Offer_Status__c != 'Withdrawn')))))
               ? 'hideDeleteOption' : 'slds-grid';
    }
}