import { LightningElement, track, api,wire } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import callGetCommunityURL from '@salesforce/apex/PBS_Leasing_PropertyController.callGetCommunityURL';
import getPropertyDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyDetails';
import saveProperty from '@salesforce/apex/PBS_Leasing_PropertyController.saveProperty';
import updateOfferRecord from '@salesforce/apex/PBS_Leasing_PropertyController.updateOfferRecord';
import validateProperty from '@salesforce/apex/PBS_Leasing_PropertyController.validateProperty';
import Info_Icon from '@salesforce/resourceUrl/Info_Icon';
import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyOfferDetails';
export default class PropertyForm extends NavigationMixin(LightningElement) {
    @api propertyId = '';
    @api offerId = '';
    @track maxCharLimit = 250;   
    saveActionName = '';
    navigateURL = '';
    errors = '';
    infoDetials = '';
    error =[];
    editMode = false;
    infoMessages = [];    
    isReadyToSubmit = false;
    @track propertyDetails = {};
    @track offerDetails = {};
    infoIconImage = Info_Icon;
    yesNoOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];
    @track isShowModal = false;
    @track offerRecordType = '';

    hideModalBox() {  
        this.isShowModal = false;
    } 

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;
            let edit = currentPageReference.state.edit;
            console.log('edit', (edit != undefined));
            if(edit != undefined){
                this.editMode = (edit == 'true' ? true : false);
            }else{
                this.editMode = true;
            }
            console.log('edit', edit);
        }
    }
    connectedCallback() {
        var href = window.location.href;
        if (this.propertyId) {
            getPropertyOfferDetails({ recordId: this.propertyId })
                .then(result => {
                    console.log('result propertyDetails ', result);
                    this.propertyDetails = this.mapWrapperFields(result);
                    this.total = result.PBS_AAAP_GEN_PURPOSE_RENTABLE;
                })
                .catch(error => {
                    // Handle error
                });
        }

        if(this.offerId && this.offerId != undefined)
            {
            getPropertyOfferDetails({ recordId: this.offerId})
            .then(result => {
                console.log('NEWOFFERresult ', result);
                console.log('NEWOFFERJSONSTRING',JSON.stringify(result));

                this.offerDetails = this.mapWrapperFields(result);
                this.offerRecordType = result.offerRecordType;
                this.offerDetails['Property__c'] = result.offerPropertyId;
                this.offerDetails['PBS_AAAP_floors_Suites_in_Offered_Space__c'] = result.PBS_AAAP_floors_Suites_in_Offered_Space;
                this.offerDetails['PBS_AAAP_Building_Common_Area_Factor__c'] = result.PBS_AAAP_Building_Common_Area_Factor;
                if(offerRecordType === 'RSAP')
                    {
                    this.offerDetails['PBS_RSAP_Year_Built__c'] = result.PBS_AAAP_Year_Built;
                    this.offerDetails['PBS_RSAP_Renovation_Year__C'] = result.PBS_AAAP_Renovation_Year;
                    this.offerDetails['PBS_AAAP_Year_Built__c'] = result.PBS_AAAP_Year_Built; 
                    this.offerDetails['PBS_AAAP_Renovation_Year__C'] = result.PBS_AAAP_Renovation_Year;
                    }
                console.log('NEWOFFERDETAILSBEFOREUPDATE',JSON.stringify(this.offerDetails));
                
                
            })
            .catch(error => {
                // Handle error
            });
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
        this.propertyDetails[event.target.fieldName] = event.target.value;
        this.offerDetails[event.target.fieldName] = event.target.value;
        
        console.log('OFFERDETAILSINPUTCHANGE',this.offerDetails);
    }

    handleParkingOnsiteChange(event) {
        this.propertyDetails.PBS_AAAP_Parking_Onsite__c = event.detail.value;
        this.offerDetails.PBS_AAAP_Parking_Onsite__c = event.detail.value;
    }
    handleRenovationYearChange(event) {
        this.propertyDetails.PBS_AAAP_Renovation_Year__c =event.target.value;
        
        this.offerDetails.PBS_AAAP_Renovation_Year__c =event.target.value;
        if(offerRecordType === 'RSAP')
            {
            this.offerDetails['PBS_RSAP_Renovation_Year__C'] = event.target.value;
            }
    }
    handleSave(event) {
        this.saveActionName = 'Save';
        if(this.offerId)
        {
        
          this.updateOffer();  
        }
        else{
        this.savePropertyInfo();
        }
    }
    handleNext() {
        if(!this.editMode){

                if((!this.offerId) && (this.offerId === undefined))
                    {
                    window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&propertyId=' + this.propertyId;
                    }
                    else if(this.offerId &&(this.propertyId != '' && this.propertyId != undefined && this.propertyId != null)){
                        window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+this.propertyId;
                    }
                    else if(this.offerId)
                    {
                        window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&offerId=' +this.offerId;
                    }
        }else{
            this.saveActionName = 'SaveAndNext';
            
            if(this.offerId)
            {
            this.updateOffer();  
            }
            else{
            this.savePropertyInfo();
            }
        }
    }
    updateOffer()
 {
    console.log('OFFERDETAILSBEFOREUPDATE',this.offerDetails);
    this.offerDetails['PBS_AAAP_GEN_PURPOSE_RENTABLE__c'] = this.total;
    this.offerDetails['PBS_AAAP_Building_Common_Area_Factor__c'] = parseFloat(this.commonAreaFactor.replace('%',''));
    console.log('After OFFERDETAILSBEFOREUPDATE',this.offerDetails);
    updateOfferRecord({ offerRecord: this.offerDetails, pageName: 'Offer-Overview'})
    .then(result => {
           if(result.isSuccess === true)
           {
            if(this.offerId && (this.propertyId != '' && this.propertyId != undefined && this.propertyId != null)){
                window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+this.propertyId;
            }
            else if(this.offerId)
                {
                    window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&offerId=' +this.offerId;
                }
           }
           
        else {
            const scrollOptions = {
                left: 0,
                top: 0,
                behavior: 'smooth'
            }
            window.scrollTo(scrollOptions);
            this.errors = result.errorMessages;
        }
    })
    .catch(error => {
        console.error('Error updating offer record:', error);
    }); 
 }
    handleBack() {
        if((!this.offerId) && (this.offerId === undefined))
        {
            window.location.href = '/leasing/s/Offer-Location?edit='+this.editMode+'&propertyId=' + this.propertyId;
        }
        else if(this.offerId && (this.propertyId != '' && this.propertyId != undefined && this.propertyId != null)){
            window.location.href = '/leasing/s/Offer-Location?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+this.propertyId;
        }
        else if(this.offerId)
            {
                window.location.href = '/leasing/s/Offer-Location?edit='+this.editMode+'&offerId=' +this.offerId;
            }
        else {
            console.error('PropertyId is not provided');
        }
    }
    handleExit() {
        if (confirm('Please make sure that, you have saved changes to the property, before leaving from this page.')) {
            window.parent.location.href = 'Offer-Home';
        }
    }
    savePropertyInfo() {
        this.errors = [];
        this.propertyDetails['PBS_AAAP_GEN_PURPOSE_RENTABLE__c'] = this.total;
        console.log(this.propertyDetails);
            this.propertyDetails.PBS_AAAP_Common_Area_Factor__c = parseFloat(this.commonAreaFactor.replace('%',''));
       
        saveProperty({ propertyRecord: this.propertyDetails,pageName : 'Offer-Overview' })
            .then((response) => {
                console.log('response ', response);
                if (response.isSuccess === true) {
                    if (this.saveActionName == 'SaveAndNavigate') {
                        window.location.href = this.navigateURL;
                    } else if (this.saveActionName == 'SaveAndNext') {
                        if (this.offerId) {
                            window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&offerId=' + this.offerId+'&propertyId='+this.propertyId;
                        }
                        else{
                        window.location.href = '/leasing/s/Offer-Owner?edit='+this.editMode+'&propertyId=' + this.propertyId;
                        }
                    } else if (this.saveActionName == 'Save') {
                        window.location.reload();
                    }
                    console.log('successfully');
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
                console.error('Error updating picklist field', error);
            });
    }
    get offerProp() {
        if(this.offerId)
        {
        return this.offerDetails;
        }
        else if(this.propertyId)
        {
            return this.propertyDetails;
        }
    }
    get isForPropertyId() {
        return this.offerId == '' ? true : false;
    }
    get isForOfferId() {
        return this.offerId == '' ? false : true;
    }
    handleNavigateToPage(ev) {
        console.log('handleNavigateToPage');
        if(!this.editMode){
            window.location.href = ev.detail.message;
        }else{
            this.saveActionName = 'SaveAndNavigate';
            this.navigateURL = ev.detail.message;
            console.log(ev.detail.message);
            if(this.offerId)
            {
            this.updateOffer();  
            }
            this.savePropertyInfo();
        }
    }
    get commonAreaFactor() {
        if(this.offerId)
        {
            if (this.offerDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0) {
                return ((this.total - this.offerDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c) / this.offerDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c * 100).toFixed(2) + '%';
            } else {
                return '0.00';
            }
        }
        else if(this.propertyId)
        {
            if (this.propertyDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c > 0) {
                return ((this.total - this.propertyDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c) / this.propertyDetails.PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c * 100).toFixed(2) + '%';
            } else {
                return '0.00';
            }
       }
    }
    get total() {
        if(this.offerId)
        {
            return (this.offerDetails.PBS_AAAP_OFFICE_SPACE_RSF__c != '' && this.offerDetails.PBS_AAAP_OFFICE_SPACE_RSF__c != undefined ? parseFloat(this.offerDetails.PBS_AAAP_OFFICE_SPACE_RSF__c) : 0) 
            + (this.offerDetails.PBS_AAAP_RETAIL_SPACE_RSF__c != '' && this.offerDetails.PBS_AAAP_RETAIL_SPACE_RSF__c != undefined ?  parseFloat(this.offerDetails.PBS_AAAP_RETAIL_SPACE_RSF__c) : 0)
            + (this.offerDetails.PBS_AAAP_GARAGE_SPACE_RSF__c != '' && this.offerDetails.PBS_AAAP_GARAGE_SPACE_RSF__c != undefined ?  parseFloat(this.offerDetails.PBS_AAAP_GARAGE_SPACE_RSF__c) : 0);
        }
        else if(this.propertyId)
        {
        return (this.propertyDetails.PBS_AAAP_OFFICE_SPACE_RSF__c != '' && this.propertyDetails.PBS_AAAP_OFFICE_SPACE_RSF__c != undefined ? parseFloat(this.propertyDetails.PBS_AAAP_OFFICE_SPACE_RSF__c) : 0) 
        + (this.propertyDetails.PBS_AAAP_RETAIL_SPACE_RSF__c != '' && this.propertyDetails.PBS_AAAP_RETAIL_SPACE_RSF__c != undefined ?  parseFloat(this.propertyDetails.PBS_AAAP_RETAIL_SPACE_RSF__c) : 0)
        + (this.propertyDetails.PBS_AAAP_GARAGE_SPACE_RSF__c != '' && this.propertyDetails.PBS_AAAP_GARAGE_SPACE_RSF__c != undefined ?  parseFloat(this.propertyDetails.PBS_AAAP_GARAGE_SPACE_RSF__c) : 0);
        }
    }
    get selectedValue() {
        if(this.offerId)
        {
        return this.offerDetails.PBS_AAAP_Parking_Onsite__c;
        }
        else if(this.propertyId)
        {
        return this.propertyDetails.PBS_AAAP_Parking_Onsite__c;
        }
    }
    get charCount() {
        if(this.offerId)
        {
            return this.offerDetails.PBS_AAAP_Renovation_Year__c!=undefined ? this.offerDetails.PBS_AAAP_Renovation_Year__c.length : 0;
        }
        else if(this.propertyId)
        {
        return this.propertyDetails.PBS_AAAP_Renovation_Year__c!=undefined ? this.propertyDetails.PBS_AAAP_Renovation_Year__c.length : 0;
        }
    }
    handleReviewProperty() {
        confirm.log('validateProperty', validateProperty);
        validateProperty({ propertyId: this.propertyId, pageName : 'Offer-Overview' })
            .then(result => {
                window.scrollTo({ top: 0, behavior: 'smooth' });
                this.error = result.errorMessages;
                console.log('this.error>>>>>>>>>>>>',this.error);
                this.infoMessages = result.infoMessages;
                console.log('this.infoMessages>>>>>>>>>>>>',this.infoMessages);
                this.isReadyToSubmit = result.success;
                console.log('this.isReadyToSubmit>>>>>>>>>>>>',this.isReadyToSubmit);
            })
            .catch(error => {
                console.log(error);
            })
    }
    openHandleModal(event){
        console.log('openHandleModal ',event.target.dataset.infotype);
        if(event.target.dataset.infotype == 'Total rentable square feet'){
            this.infoDetials = 'Rentable Space or Rentable Square Feet (RSF) means the area for which a tenant is charged rent. It is determined by the building owner and may vary by city or by building within the same city. Rentable space may include a share of common areas such as elevator lobbies, building corridors, and floor service areas. Floor service areas typically include restrooms, janitor rooms, telephone closets, electrical closets, and mechanical rooms. Rentable space does not include vertical building penetrations and their enclosing walls, such as stairs, elevator shafts, and vertical ducts. To determine the RSF, the ABOA SF is multiplied by the sum of one (1) plus the CAF, for each type of space included in the premises. <br/><br/>Refer to section 2, Definitions and General Terms, of the lease';
        }else if(event.target.dataset.infotype == 'ABOA'){
            this.infoDetials = 'The government recognizes the American National Standards Institute/Building Owners and Managers Association (ANSI/BOMA) international standard (Z65.1-2017) definition for Occupant Area, which means “the total aggregated area used by an Occupant before Load Factors are applied, consisting of Tenant Area and Tenant Ancillary Area.” The Method A – Multiple Load Factor Method shall apply. References to ABOA mean ANSI/BOMA Occupant Area. <br/><br/>Refer to section 2, Definitions and General Terms, of the lease';
        }
        else if(event.target.dataset.infotype == 'CAF'){
            this.infoDetials = 'Common Area Factor (CAF) means a conversion factor determined and applied by the building owner to determine the rentable square feet for the leased space. The CAF is expressed as a percentage of the difference between the amount of rentable square feet (SF) and ABOA SF, divided by the ABOA SF.  The CAF shall be determined in accordance with the applicable ANSI/BOMA standard for the type of space to which the CAF shall apply.';
        }else if(event.target.dataset.infotype == 'Operating Costs'){
            this.infoDetials = 'For lease requirements related to provision of services, access, and normal hours refer to section 6 PROVISION OF SERVICES, ACCESS, AND NORMAL HOURS of the lease.<br/><br/> For HVAC requirements refer to section 6 HEATING AND AIR CONDITIONING (AAAP VARIATION) of the lease. <br/><br/> For information about providing HVAC services outside normal hours of operations, refer to section 6 OVERTIME HVAC USAGE of the lease.';
        }
        this.isShowModal = true;
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
                    PBS_AAAP_DUNS_Number__c:data.PBS_AAAP_DUNS_Number,
                    PBS_AAAP_Offer_Status__c:data.PBS_AAAP_Offer_Status,
                    PBS_RLPORSolicitation_Number:data.PBS_RLPORSolicitation_Number
        };
    }
    get offer() {
        return this.propertyDetails;
    }
    get isDisabled(){
        return !this.editMode;
    }
}