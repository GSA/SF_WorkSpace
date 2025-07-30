import { LightningElement, track, api, wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyOfferDetails';
import updateOfferRecord from '@salesforce/apex/PBS_Leasing_PropertyController.updateOfferRecord';
import saveProperty from '@salesforce/apex/PBS_Leasing_PropertyController.saveProperty';
import copyUserDetails from '@salesforce/apex/PBS_Leasing_PropertyController.copyUserDetails';
import Info_Icon from '@salesforce/resourceUrl/Info_Icon';

export default class PBS_LeasingPropertyOwner extends NavigationMixin(LightningElement) {

    @api offerId = '';
    @api propertyId = '';
    saveActionName = '';
    navigateURL = '';
    errors = '';
    error =[];
    editMode = false;
    infoIconImage = Info_Icon;
    infoDetails = '';

    @track propertyOfferDetails = {};
    
    @track isShowModal = false;
    
    infoIconImage = Info_Icon;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;
            let edit = currentPageReference.state.edit;
            console.log('edit>>>>>>>>>', edit);
            if(edit != undefined){
                this.editMode = (edit == 'true' ? true : false);
            }else{
                this.editMode = true;
            }
        }
    }

    get isDisabled(){
        return !this.editMode;
    }

    connectedCallback() {
        console.log('Starting connectedCallback(), this.propertyId = ' + this.propertyId + ', this.offerId = ' + this.offerId);
        if (this.offerId) {
            getPropertyOfferDetails({ recordId: this.offerId })
                .then(result => {
                    this.propertyOfferDetails = result;
                    
                    
                    console.log('propertyOfferDetails: ' + JSON.stringify(this.propertyOfferDetails));
                })
                .catch(error => {
                    // Handle error
                });
        } else {
            if (this.propertyId) {
                getPropertyOfferDetails({ recordId: this.propertyId })
                    .then(result => {
                        this.propertyOfferDetails = result;
                        console.log('propertyOfferDetails: ' + JSON.stringify(this.propertyOfferDetails));
                    })
                    .catch(error => {
                        // Handle error
                    });
            }
        }
    }
    renderedCallback() {
        const radioGroup = this.template.querySelector('.horizontal-radio');
        if (radioGroup) {
            const formElementControl = radioGroup.shadowRoot.querySelector('.slds-form-element__control');
            if (formElementControl) {
                formElementControl.style.display = 'flex';
            }
        }
    }
    handleInputChange(event) {
        console.log('In handleInputChange() with target ' + event.target.fieldName + ' and value ' + event.target.value);
        
        let wrapperFieldName = event.target.fieldName.replace('__c', '');
        console.log('About to update fieldName ' + wrapperFieldName + ' in the wrapperObject to value ' + event.target.value + '...');
        this.propertyOfferDetails[wrapperFieldName] = wrapperFieldName == 'PBS_RSAP_Property_Owner_Same_as_Offeror' ? event.target.value : event.target.value.trim() == '' ? null : event.target.value;
        console.log('Wrapper updated and now checking event.target.fieldName for PBS_RSAP_Property_Owner_Same_as_Offeror__c...');
        
        if (event.target.fieldName == 'PBS_RSAP_Property_Owner_Same_as_Offeror__c' &&
            event.target.value === true) { //user just checked the "same as offeror" checkbox
                console.log('About to call this.copyUserDetailsInfo()...');
                this.copyUserDetailsInfo();
                window.location.reload();
        } else {
            console.log('Was not the "same as offeror" checkbox field updated so do nothing more.');
        }           
    }
    handleSave(event) {
        console.log('Inside handleSave()...');
        this.saveActionName = 'Save';
        this.savePropertyOfferInfo();
    }
    handleNext() {
        if(!this.editMode){
            if (this.offerId && this.propertyId) {
                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
            } else if (this.offerId) {
                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&offerId=' + this.offerId;
            } else if (this.propertyId) {
                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&propertyId=' + this.propertyId;
            }
        }else{
            console.log('Inside handleNext()...');
            this.saveActionName = 'SaveAndNext';
            this.savePropertyOfferInfo();
        }
    }
    handleBack() {
        if (this.offerId && this.propertyId) {
            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
        } else if (this.offerId) {
            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' + this.offerId;
        } else if (this.propertyId) {
            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&propertyId=' + this.propertyId;
        } else {
            console.error('Missing OfferId and PropertyId so cannot support Back button.');
        }
    }
    handleExit() {
        if (confirm('Please make sure that, you have saved changes to the property, before leaving from this page.')) {
            window.parent.location.href = 'Offer-Home';
        }
    }
    savePropertyOfferInfo() {
        console.log('Inside savePropertyOfferInfo()...');
        
        this.errors = [];
        if (this.offerId) {
            updateOfferRecord({ offerRecord: this.mapWrapperFields(this.propertyOfferDetails), pageName: 'Offer-Owner' })
                .then((response) => {
                    console.log('response ', response);
                    if (response.isSuccess === true) {
                        if (this.saveActionName == 'SaveAndNavigate') {
                            window.location.href = this.navigateURL;
                        } else if (this.saveActionName == 'SaveAndNext') {
                            if (this.offerId && this.propertyId) {
                                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
                            } else if (this.offerId) {
                                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&offerId=' + this.offerId;
                            } else if (this.propertyId) {
                                window.location.href = '/leasing/s/Offer-RLP?edit='+this.editMode+'&propertyId=' + this.propertyId;
                            } else {
                                console.error('Missing OfferId and PropertyId so cannot support Back button.');
                            }
                        } else if (this.saveActionName == 'Save') {
                            window.location.reload();
                        }
                        console.log('successful Offer Save');
                    } else {
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
                    console.error('Error updating fields', error);
                });
        } else {
            if (this.propertyId) {
                saveProperty({ propertyRecord: this.mapWrapperFields(this.propertyOfferDetails), pageName: 'Offer-Owner' })
                    .then((response) => {
                        console.log('response ', response);
                        if (response.isSuccess === true) {
                            if (this.saveActionName == 'SaveAndNavigate') {
                                window.location.href = this.navigateURL;
                            } else if (this.saveActionName == 'SaveAndNext') {
                                window.location.href = this.offerId ? '/leasing/s/Offer-RLP?edit='+this.editMode+'&offerId=' + this.offerId : '/leasing/s/Offer-RLP?edit='+this.editMode+'&propertyId=' + this.propertyId;
                            } else if (this.saveActionName == 'Save') {
                            window.location.reload();
                            }
                            console.log('successful Save');
                        } else {
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
                        console.error('Error updating fields', error);
                    });
            }
        }
    }
    copyUserDetailsInfo() {
        console.log('Inside copyUserDetailsInfo()...');
        copyUserDetails({ myRecord: this.propertyOfferDetails })
            .then((response) => {
                console.log('response ', response);
                if (response.isSuccess === true) {
                    window.location.reload();
                    console.log('successful Copy');
                } else {
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
                console.error('Error updating fields', error);
            });
    }    
    handleNavigateToPage(ev) {
        if(!this.editMode){
            window.location.href = ev.detail.message;
        }else{
            this.saveActionName = 'SaveAndNavigate';
            this.navigateURL = ev.detail.message;
            this.savePropertyOfferInfo();
        }
    }
    get offer() {
        return this.propertyOfferDetails;
    }
    get isForPropertyId() {
        return this.offerId == '' ? true : false;
    }
    get isForOfferId() {
        return this.offerId == '' ? false : true;
    }
    get rlpOrSolicitationLabel() {
        if (this.propertyOfferDetails.offerRecordType == 'AAAP') {
            return 'RLP Number';
        } else {
            return 'RLP Number';
        }
    }
    get offerorInterestOther() {
        console.log('getting offerorInterestOther css class for offeror interest ' + this.propertyOfferDetails.PBS_AAAP_OFFEROR_INTEREST);
        return (this.propertyOfferDetails.PBS_AAAP_OFFEROR_INTEREST == 'Other') ? 'offerorInterestOtherShow' : 'offerorInterestOtherHide';        
    }
    openHandleModal(event){
        console.log('openHandleModal ',event.target.dataset.infotype);
        this.infoDetails = '';
        if(event.target.dataset.infotype == 'OfferorInterest'){
            this.infoDetails = "Offerors shall own the offered property or have authorization to represent the ownership. Offerors selecting Agent or Other must upload documentation supporting a formal, legally-binding agreement with the offered property's ownership as the Authorization to Represent Ownership Entity attachment type in the Attachments page.";
        }else if(event.target.dataset.infotype == 'UEINumber'){
            this.infoDetails = "The Unique Entity Identifier (UEI) is a 12-character alphanumeric value assigned, managed, and owned by the federal government. The System for Award Management (SAM) located at HTTPS://SAM.GOV is the system that assigns a UEI. The Offeror must register their entity in SAM.gov when they want to bid on federal contracts. SAM registration and the UEI is required prior to lease award, unless stated otherwise in the RLP. If you are not already registered in SAM.gov, please begin the process to obtain one early to ensure compliance with the RLP. The registration service is free of charge.";
        }
        this.isShowModal = true;
    }
    hideModalBox() {  
        this.isShowModal = false;
    } 
    mapWrapperFields(data) {
        return {
                
                Id:data.Id,
                PBS_AAAP_Building_Name__c:data.PBS_AAAP_Building_Name,
                PBS_AAAP_Street_Address__c:data.PBS_AAAP_Street_Address,
                PBS_AAAP_User_Defined_Address__c: data.PBS_AAAP_User_Defined_Address,
                PBS_AAAP_City__c:data.PBS_AAAP_City,
                PBS_AAAP_State__c:data.PBS_AAAP_State,
                PBS_AAAP_County__c:data.PBS_AAAP_County,
                PBS_AAAP_X_CO_ORD__c:data.PBS_AAAP_X_CO_ORD,
                PBS_AAAP_Y_CO_ORD__c:data.PBS_AAAP_Y_CO_ORD,
                PBS_AAAP_ZipCode__c:data.PBS_AAAP_ZipCode,
                PBS_AAAP_floors_Suites_in_Offered_Space__c:data.PBS_AAAP_floors_Suites_in_Offered_Space,
                PBS_AAAP_OFFICE_SPACE_RSF__c:data.PBS_AAAP_OFFICE_SPACE_RSF,
                PBS_AAAP_RETAIL_SPACE_RSF__c:data.PBS_AAAP_RETAIL_SPACE_RSF,
                PBS_AAAP_GARAGE_SPACE_RSF__c:data.PBS_AAAP_GARAGE_SPACE_RSF,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c:data.PBS_AAAP_GEN_PURPOSE_RENTABLE,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c:data.PBS_AAAP_TOTAL_BOMA_USF_OFFERED,
                PBS_AAAP_Common_Area_Factor__c:data.PBS_AAAP_Common_Area_Factor,
                PBS_AAAP_Total_Surface_Parking_Spaces__c:data.PBS_AAAP_Total_Surface_Parking_Spaces,
                PBS_AAAP_Total_Structured_Parking_Spaces__c:data.PBS_AAAP_Total_Structured_Parking_Spaces,
                PBS_AAAP_Total_Park_Spaces_Offered__c:data.PBS_AAAP_Total_Park_Spaces_Offered,
                PBS_AAAP_Year_Built__c:data.PBS_AAAP_Year_Built,
                PBS_AAAP_Renovation_Year__c:data.PBS_AAAP_Renovation_Year,
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c:data.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START,
                PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c:data.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END,
                PBS_AAAP_HVAC_HRS_ON_SAT_START__c:data.PBS_AAAP_HVAC_HRS_ON_SAT_START,
                PBS_AAAP_HVAC_HRS_ON_SAT_END__c:data.PBS_AAAP_HVAC_HRS_ON_SAT_END,
                PBS_AAAP_HVAC_HRS_ON_SUN_START__c:data.PBS_AAAP_HVAC_HRS_ON_SUN_START,
                PBS_AAAP_HVAC_HRS_ON_SUN_END__c:data.PBS_AAAP_HVAC_HRS_ON_SUN_END,
                PBS_AAAP_Owner_Name__c:data.PBS_AAAP_Owner_Name,
                PBS_RSAP_Property_Owner_Same_as_Offeror__c:data.PBS_RSAP_Property_Owner_Same_as_Offeror,
                PBS_AAAP_Owner_Address__c:data.PBS_AAAP_Owner_Address,
                PBS_AAAP_Owner_City__c:data.PBS_AAAP_Owner_City,
                PBS_AAAP_Owner_State__c:data.PBS_AAAP_Owner_State,
                PBS_AAAP_Owner_Zip__c:data.PBS_AAAP_Owner_Zip,
                PBS_AAAP_Parking_Onsite__c:data.PBS_AAAP_Parking_Onsite,
                PBS_AAAP_OFFEROR_INTEREST__c:data.PBS_AAAP_OFFEROR_INTEREST,
                
                PBS_AAAP_OFFEROR_INTEREST_OTHER__c:data.PBS_AAAP_OFFEROR_INTEREST_OTHER,
                PBS_AAAP_DUNS_Number__c:data.PBS_AAAP_DUNS_Number
                
        };
	}
}