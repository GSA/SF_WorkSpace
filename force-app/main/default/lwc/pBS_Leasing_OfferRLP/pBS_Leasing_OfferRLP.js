import { LightningElement, track, api,wire } from 'lwc';
import searchRecords from '@salesforce/apex/PBS_Leasing_OfferRLPController.searchRecords';
import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_OfferRLPController.getPropertyOfferDetails';
import createOfferRecord from '@salesforce/apex/PBS_Leasing_OfferRLPController.createOfferRecord';
import updateOfferRecord from '@salesforce/apex/PBS_Leasing_OfferRLPController.updateOfferRecord';
import validateAllPropertyDetails from '@salesforce/apex/PBS_Leasing_PropertyController.validateAllPropertyDetails';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

export default class PBS_Leasing_OfferRLP extends NavigationMixin(LightningElement) {
    @track rlpNumber = ''; 
    @track rlpType;  
    @track rlpId;
    @track yearBuilt;
    @track yearRenovation;
    @track noOfFloors;
    @track propertyName;
    @track offerStatus;
    @api propertyId;
    @track solicitationNumber;
    @track showRLPFound = false;
    @track showAAAPRLPFound = false;
    @track showRSAPRLPFound = false;
    @track showRLPNotFound = false;
    @track showAddressNotFound = false;
    @track city;
    @track state;
    @track prefixId;
    @track propertyRecordDetails = {};
    @track offerDetails = {};
    @track isReadonly = false;
    @track showButton = true;
    @track showNextButton = true;
    @track offerId;
    @track validationPageName= 'Offer-RLP';
    pageName;
    PageURL;
    errors = '';
    error =[];
    editMode;
    saveActionName = '';
    @track objectType = 'Property';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;

            if(this.offerId) {
                this.isReadonly = true;
                this.showButton = false;
            }

            if(this.propertyId)
            {
               getPropertyOfferDetails({ recordId: this.propertyId})
                        .then(result => {
                            console.log('result ', result);
                    
                            this.propertyRecordDetails = result;
                            this.propertyName = result.PBS_AAAP_Building_Name;
                            this.city = result.PBS_AAAP_City;
                            this.state = result.PBS_AAAP_State;
                          
                        })
                        .catch(error => {
                            
                        });
        
             }
            console.log('PropertyId Page reference ', this.propertyId);

            let edit = currentPageReference.state.edit;
            console.log('edit', (edit != undefined));
            if(edit != undefined){
                this.editMode = (edit == 'true' ? true : false);
            }else{
                this.editMode = true;
            }
        }
    }

   connectedCallback() {
   
    this.pageName = window.location.pathname.substring(11);
    this.PageURL = decodeURIComponent(encodeURIComponent(window.location.origin));
    if(this.offerId) {
        this.isReadonly = true;
        getPropertyOfferDetails({ recordId: this.offerId})
            .then(result => {
                console.log('NEWOFFERresult ', result);
                console.log('NEWOFFERJSONSTRING',JSON.stringify(result));
                this.offerStatus = result.PBS_AAAP_Offer_Status;
                this.rlpNumber = result.PBS_AAAP_RLPNumber;
                this.rlpType = 'AAAP';
                this.solicitationNumber = result.PBS_RSAP_RLPNumber;
                if(this.solicitationNumber){
                    this.rlpNumber = result.PBS_RSAP_RLPNumber;
                    this.rlpType = 'RSAP';
                }
                this.city = result.PBS_AAAP_City;
                this.state = result.PBS_AAAP_State;
            })
            .catch(error => {
                
            });
    }
    if(this.propertyId)
    {
        getPropertyOfferDetails({ recordId: this.propertyId})
            .then(result => {
                console.log('NEWresult ', result);
                console.log('NEWJSONSTRING',JSON.stringify(result));
                this.propertyRecordDetails = result;
                this.offerDetails = this.mapWrapperFields(result);
                console.log('OFFERDETAILS',this.offerDetails);
                this.yearBuilt = result.PBS_AAAP_Year_Built;
                this.yearRenovation = result.PBS_AAAP_Renovation_Year;
                this.noOfFloors = result.PBS_AAAP_floors_Suites_in_Offered_Space;
                this.city = result.PBS_AAAP_City;
                this.state = result.PBS_AAAP_State;
            })
            .catch(error => {
                
            });  
            
        }     
           
}

handleInputChange(event) {
        this.rlpNumber = event.target.value;
        this.offerDetails.PBS_AAAP_RLP_Number__c = event.target.value;
        console.log('INPUTRLPNUM'+this.rlpNumber);
    }

    // Handle the search action
handleSearch() {
    console.log('handleSearch ', this.rlpNumber);
        if (this.rlpNumber) {
            var pages = ['Offer-Location','Offer-Overview','Offer-Owner'];
            this.errors = [];
            validateAllPropertyDetails({ propertyId:this.propertyId, pages:pages})
            .then(res=> {
                console.log('res' ,res);
                if(res.errorMessages.length > 0){
                    this.errors = res.errorMessages;
                }else{
                    searchRecords({ searchValue: this.rlpNumber , propertyId:this.propertyId})
                    .then(result=> {
                        console.log('RESULT' ,result);
                        if(result.isValidRLP === false)
                        {
                            this.showRLPNotFound = true;
                            this.showRLPFound = false;
                            this.showAAAPRLPFound = false;
                            this.showRSAPRLPFound = false;
                            this.showAddressNotFound = false;
                            this.showNextButton = false;
                            this.showButton = true;
                        }
                        else if(result.isValidAddress === false){
                            this.showRLPFound = false;
                            this.showRLPNotFound = false;
                            this.showAAAPRLPFound = false;
                            this.showRSAPRLPFound = false;
                            this.showAddressNotFound = true;
                            this.showNextButton = false;
                            this.showButton = true;
                            
                        }
                        else{
                            this.showRLPFound = true;
                            this.showRLPNotFound = false;
                            this.showAddressNotFound = false;
                        }
                        this.rlpNumber = result.rlpRecord.PBS_AAAP_RLP_Number__c;
                        if(this.rlpNumber)
                        {
                        this.rlpType = 'AAAP';
                        }
                        this.rlpId = result.rlpRecord.Id;
                        this.offerDetails.PBS_AAAP_RLP_Number__c = this.rlpId;
                        console.log('RLPNUM' +this.rlpNumber);
                        console.log('RLPID' +this.rlpId);
                        this.solicitationNumber = result.rlpRecord.PBS_RSAP_Solicitation_Number__c;
                        if (this.solicitationNumber)
                        {
                            this.rlpNumber = result.rlpRecord.PBS_RSAP_Solicitation_Number__c;
                            this.rlpType = 'RSAP';
                            
                        }
                        if(this.rlpType === 'AAAP' && result.isValidAddress === true)
                        {
                            this.showAAAPRLPFound = true;
                            this.showButton = false;
                            this.showRSAPRLPFound = false;
                            this.offerDetails['PBS_AAAP_Year_Built__c'] = this.yearBuilt;
                            this.offerDetails['PBS_AAAP_Renovation_Year__c'] = this.yearRenovation;
                            this.offerDetails['PBS_AAAP_Number_of_floors__c'] = this.noOfFloors;
                        }
                        else if(this.rlpType === 'RSAP' && result.isValidAddress === true){
                            this.showRSAPRLPFound = true;
                            this.showButton = false;
                            this.showAAAPRLPFound = false;
                            this.offerDetails['PBS_RSAP_Year_Built__c'] = this.yearBuilt;
                            this.offerDetails['PBS_RSAP_Renovation_Year__c'] = this.yearRenovation;
                            this.offerDetails['PBS_AAAP_floors_Suites_in_Offered_Space__c'] = this.noOfFloors;
                        }
                        this.error = undefined;
                    })
                    .catch(error => {
                        console.log(error);
                        this.error = error;
                        this.records = undefined;
                    });
                }
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.records = undefined;
            });
        }
}
handleCreate(){
  console.log('OFFERDETAILSBEFORECREATE' +this.offerDetails);
  this.createOffer();
  this.saveActionName = 'SaveAndNext';
}

createOffer() {
    this.errors = [];
    if((this.offerId && this.offerId != undefined) && this.saveActionName != 'SaveAndNavigate'){
        if (this.offerId && this.rlpType === 'AAAP'){
            window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
        }
        else if (this.offerId && this.rlpType === 'RSAP'){
            window.location.href = '/leasing/s/Offer-S-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
        }
    }

    
    else
    {
    console.log('OFFERDETAILSBEFORECREATE',this.offerDetails);
    createOfferRecord({ offerRecord: this.offerDetails ,pageName: this.validationPageName, rType: this.rlpType})
        .then((response) => {
            console.log('response ', response);
            if (response.isSuccess === true) {
                if (this.saveActionName == 'SaveAndNavigate') {
                    window.location.href = this.navigateURL;
                } else if (this.saveActionName == 'SaveAndNext' && this.rlpType === 'AAAP') {
                    window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + response.offerId +'&propertyId='+this.propertyId;
                   }
                    else if (this.saveActionName == 'SaveAndNext' && this.rlpType === 'RSAP') {
                        window.location.href = '/leasing/s/Offer-S-Eligibility?edit='+this.editMode+'&offerId=' + response.offerId +'&propertyId='+this.propertyId;
                    }
                else if (this.saveActionName == 'Save') {
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
                console.log('CREATEOFFERERRORMESSAGEIS' +response.errorMessages);
                this.errors = response.errorMessages;
            }
        })
        .catch(error => {
            console.error('Error updating Offer field', error);
        });
    }
}

handleNext(){
    this.errors = [];
    if(this.rlpNumber == null || this.rlpNumber == undefined || this.rlpNumber == '')
    {
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
        this.errors[0] = 'Offer-RLP Page: 1. RLP Number is required.';
        
    }
    if(this.editMode){
        var pages = ['Offer-Location','Offer-Overview','Offer-Owner'];
        this.errors = [];
        validateAllPropertyDetails({ propertyId:this.propertyId, pages:pages})
        .then(res=> {
            console.log('res' ,res);
            if(res.errorMessages.length > 0){
                this.errors = res.errorMessages;
            }else{
                console.log('handleNavigateToPage');
                if (this.offerId && this.rlpType === 'AAAP'){
                    window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
                }else if (this.offerId && this.rlpType === 'RSAP'){
                    window.location.href = '/leasing/s/Offer-S-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
                }
            }
        })
        .catch(error => {
            console.log(error);
        });
    }else{
         if (this.offerId && this.rlpType === 'AAAP'){
            if(this.propertyId){
                window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
            }else{
                window.location.href = '/leasing/s/Offer-M-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId;
            }
            
        }else if (this.offerId && this.rlpType === 'RSAP'){
            if(this.propertyId){
                window.location.href = '/leasing/s/Offer-S-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId +'&propertyId='+this.propertyId;
            }else{
                window.location.href = '/leasing/s/Offer-S-Eligibility?edit='+this.editMode+'&offerId=' + this.offerId;
            }
        }
    }
}
handleAutoSubmit(event)
{
event.preventDefault();
}
handleBack()
{

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
}

handleExit() {
    if (confirm('Please make sure that, you have saved changes to the property, before leaving from this page.')) {
        window.parent.location.href = 'Offer-Home';
    }
}
mapWrapperFields(data) {
    return {
                Property__c:this.propertyId,
                PBS_AAAP_Building_Name__c:data.PBS_AAAP_Building_Name,
                PBS_AAAP_Street_Address__c:data.PBS_AAAP_Street_Address,
                PBS_AAAP_City__c:data.PBS_AAAP_City,
                PBS_AAAP_State__c:data.PBS_AAAP_State,
                PBS_AAAP_County__c:data.PBS_AAAP_County,
                PBS_AAAP_X_CO_ORD__c:data.PBS_AAAP_X_CO_ORD,
                PBS_AAAP_Y_CO_ORD__c:data.PBS_AAAP_Y_CO_ORD,
                PBS_AAAP_ZipCode__c:data.PBS_AAAP_ZipCode,
                PBS_AAAP_OFFICE_SPACE_RSF__c:data.PBS_AAAP_OFFICE_SPACE_RSF,
                PBS_AAAP_RETAIL_SPACE_RSF__c:data.PBS_AAAP_RETAIL_SPACE_RSF,
                PBS_AAAP_GARAGE_SPACE_RSF__c:data.PBS_AAAP_GARAGE_SPACE_RSF,
                PBS_AAAP_GEN_PURPOSE_RENTABLE__c:data.PBS_AAAP_GEN_PURPOSE_RENTABLE,
                PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c:data.PBS_AAAP_TOTAL_BOMA_USF_OFFERED,
                PBS_AAAP_Total_Surface_Parking_Spaces__c:data.PBS_AAAP_Total_Surface_Parking_Spaces,
                PBS_AAAP_Total_Structured_Parking_Spaces__c:data.PBS_AAAP_Total_Structured_Parking_Spaces,
                PBS_AAAP_Total_Park_Spaces_Offered__c:data.PBS_AAAP_Total_Park_Spaces_Offered,
                PBS_AAAP_User_Defined_Address__c:data.PBS_AAAP_User_Defined_Address,
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
                PBS_AAAP_OFFEROR_INTEREST__c:data.PBS_AAAP_OFFEROR_INTEREST,
                PBS_AAAP_Parking_Onsite__c:data.PBS_AAAP_Parking_Onsite,
                PBS_AAAP_DUNS_Number__c:data.PBS_AAAP_DUNS_Number,
                PBS_AAAP_Common_Area_Factor__c:data.PBS_AAAP_Common_Area_Factor
    };
}
handleNo(){
    this.showRLPFound = false;
    this.showAAAPRLPFound = false;
    this.showRSAPRLPFound = false;
    this.showButton = true;
    this.rlpNumber = '';
}
handleNavigateToPage(ev) {
    if(!this.editMode){
        window.location.href = ev.detail.message;
    }else{
        console.log('handleNavigateToPage '+ev.detail.message);
        if(ev.detail.message.includes('Eligibility')){
            var pages = ['Offer-Location','Offer-Overview','Offer-Owner'];
            this.errors = [];
            validateAllPropertyDetails({ propertyId:this.propertyId, pages:pages})
            .then(res=> {
                console.log('res' ,res);
                if(res.errorMessages.length > 0){
                    this.errors = res.errorMessages;
                }else{
                    console.log('handleNavigateToPage');
                    this.saveActionName = 'SaveAndNavigate';
                    this.navigateURL = ev.detail.message;
                    console.log(ev.detail.message);
                    if (this.saveActionName == 'SaveAndNavigate') {
                        window.location.href = this.navigateURL;
                    }
                }
            })
            .catch(error => {
                console.log(error);
                this.error = error;
                this.records = undefined;
            });
        }else{
            window.location.href = ev.detail.message;
        }
    }
}
handleKeyPress(event) {
    if (event.keyCode === 13)  {
        event.preventDefault();
    }
}
}