import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_OfferParkingController.getPropertyOfferDetails';
import updateOfferRecord from '@salesforce/apex/PBS_Leasing_OfferParkingController.updateOfferRecord';
import Info_Icon from '@salesforce/resourceUrl/Info_Icon';

export default class PBS_Leasing_OfferParking extends NavigationMixin(LightningElement) {

    @api offerId = '';
    
    editMode = false;
    draftMsgFlag;
    viewMsg;
    errors=[];

    @track propertyOfferDetails = {};

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;
            this.draftMsgFlag = currentPageReference.state.draftMsgFlag;
            let edit = currentPageReference.state.edit;
            if(edit != undefined){
                this.editMode = (edit == 'true' ? true : false);
            }else{
                this.editMode = true;
            }
            console.log('editMode ', this.editMode);
        }
    }

    connectedCallback() {
 
        if(this.offerId && this.offerId != undefined)
            {
            getPropertyOfferDetails({ recordId: this.offerId })
            .then(result => {
                //console.log('connectedCallBack() getPropertyOfferDetails() result ', JSON.stringify(result));
                console.log(result);
                this.propertyOfferDetails = result;
                /*
                this.propertyOfferDetails = this.mapWrapperFields(result);
                this.propertyOfferDetails['Property__c'] = result.offerPropertyId;
                this.propertyOfferDetails['PBS_AAAP_floors_Suites_in_Offered_Space__c'] = result.PBS_AAAP_floors_Suites_in_Offered_Space;
                this.propertyOfferDetails['PBS_AAAP_Building_Common_Area_Factor__c'] = result.PBS_AAAP_Building_Common_Area_Factor;
                if(result.offerRecordType === 'RSAP') {
                    this.propertyOfferDetails['PBS_RSAP_Year_Built__c'] = result.PBS_AAAP_Year_Built;
                    this.propertyOfferDetails['PBS_RSAP_Renovation_Year__C'] = result.PBS_AAAP_Renovation_Year;
                    this.propertyOfferDetails['PBS_AAAP_Year_Built__c'] = result.PBS_AAAP_Year_Built; 
                    this.propertyOfferDetails['PBS_AAAP_Renovation_Year__C'] = result.PBS_AAAP_Renovation_Year;
                }
                */
                //console.log('connectedCallBack() getPropertyOfferDetails() final result ', JSON.stringify(this.propertyOfferDetails));  
                
            })
            .catch(error => {
                // Handle error
            });
        }
        
    }
    /*
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
                    PBS_AAAP_DUNS_Number__c:data.PBS_AAAP_DUNS_Number,
                    PBS_AAAP_Offer_Status__c:data.PBS_AAAP_Offer_Status,
                    PBS_RLPORSolicitation_Number:data.PBS_RLPORSolicitation_Number,
                    PBS_AAAP_Monthly_cost_nonres_gar_park__c:data.PBS_AAAP_Monthly_cost_nonres_gar_park,
                    PBS_AAAP_Monthly_cost_res_gar_park__c:data.PBS_AAAP_Monthly_cost_res_gar_park,
                    PBS_AAAP_Monthly_cost_nonres_sur_park__c:data.PBS_AAAP_Monthly_cost_nonres_sur_park,
                    PBS_AAAP_Monthly_cost_res_sur_park__c:data.PBS_AAAP_Monthly_cost_res_sur_park
        };
    }
    */
    get isDisabled(){
        return !this.editMode;
    }

    handleInputChange(event) {
        
        console.log('In handleInputChange() with target ' + event.target.fieldName + ' and value ' + event.target.value);
        
        let wrapperFieldName = event.target.fieldName;//.replace('__c', '');
        console.log('About to update fieldName ' + wrapperFieldName + ' in the wrapperObject to value ' + event.target.value + '...');
        this.propertyOfferDetails[wrapperFieldName] = event.target.value.trim() == '' ? null : event.target.value;
            
    }

    handleSave(event) {
        
        console.log('Inside handleSave()...');
        
        this.saveActionName = 'Save';
        this.savePropertyOfferInfo();

    }

    handleNext() {
        
        if(!this.editMode){
            window.location.href = '/leasing/s/Offer-M-Costs?edit='+this.editMode+'&offerId=' + this.offerId;
        }else{
            console.log('Inside handleNext()...');
            this.saveActionName = 'SaveAndNext';
            this.savePropertyOfferInfo();
        }
    }

    handleBack() {
        if (this.offerId && this.propertyId) {
            window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
        } else if (this.offerId) {
            window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId;
        } /*else if (this.propertyId) {
            window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&propertyId=' + this.propertyId;
        } else {
            console.error('Missing OfferId and PropertyId so cannot support Back button.');
        }*/
    }

    handleExit() {
        if (confirm('Please make sure that, you have saved changes to the property, before leaving from this page.')) {
            window.parent.location.href = 'Offer-Home';
        }
    }

    savePropertyOfferInfo() {
        console.log('Inside savePropertyOfferInfo()...');
        console.log(this.propertyOfferDetails);
        //console.log(this.mapWrapperFields(this.propertyOfferDetails));
        this.errors = [];
        updateOfferRecord({ offerRecord: this.propertyOfferDetails, pageName: 'Offer-M-Parking' })
            .then((response) => {
                console.log('response ', response);
                if (response.success === true) {
                    if (this.saveActionName == 'SaveAndNavigate') {
                        window.location.href = this.navigateURL;
                    } else if (this.saveActionName == 'SaveAndNext') {
                        if(this.offerId && (this.propertyId != '' && this.propertyId != undefined && this.propertyId != null)){
                            window.location.href = '/leasing/s/Offer-M-Costs?edit='+this.editMode+'&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                        }else if(this.offerId)
                        {
                            window.location.href = '/leasing/s/Offer-M-Costs?edit='+this.editMode+'&offerId=' + this.offerId;
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

}