import { LightningElement, track,wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getOfferDetails from '@salesforce/apex/PBS_Leasing_OfferSpaceController.getOfferDetails';
import getRecords from '@salesforce/apex/PBS_Leasing_OfferSpaceController.getRecords';
import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyOfferDetails';

export default class PBS_LeasingOfferSpace extends NavigationMixin(LightningElement) {

    @track data = [
        { id: '1', propertyName: 'Test1', street: 'Test Street 1', city: 'Test City1', state: 'CA' },
        { id: '2', propertyName: 'Test2', street: 'Test Street 2', city: 'Test City2', state: 'CA' },
        // Add more property data as needed
    ];
    @track records;
    @track propList;
    @track sortedBy;
    @track sortedDirection;
    @track recordTypeName;
    @track offerPropertyId;
    @track offerBuildingName;
    @track offerABOAsqft;
    @track offerId;
    @track offerStatus;
    @track isModalOpen = false;
    @track isRLPModalOpen = false;
    
    @wire(getRecords)
    wiredRecords({ error, data }) {
        if (data) {
            //this.propList = data;
            console.log('DATA',data);
            this.propList = data.map(record => {
                // Adding awardType based on RecordType.Name
                
                let awardType = this.getAwardType(record);
                let rlpType;
                if(record.hasOwnProperty('PBS_AAAP_RLP_Number__c')){
                    rlpType = this.getRLPType(record);
                }
                return { ...record, awardType,rlpType };
                
            });
            this.hasPropData();
        } else if (error) {
            console.error(error);
        }
    }

    getAwardType(record) {
        // Check if RecordType.Name is "AAAP" to show "Single lease"
        return record.RecordType.Name === 'RSAP' ? 'Single lease' : 'Multiple lease';
    }
    
    getRLPType(record) {
        // Check if RecordType.Name is "AAAP" to show "Single lease"
        return record.RecordType.Name === 'RSAP' ? record.PBS_AAAP_RLP_Number__r.PBS_RSAP_Solicitation_Number__c : record.PBS_AAAP_RLP_Number__r.PBS_AAAP_RLP_Number__c;
    }
    get columns() {
        return [
            {
                label: '',
                type: 'button',
                typeAttributes: {
                    label: 'Select',
                    name: 'select_property',
                    variant: 'brand',
                    class: 'btn'
                }
            },
            { label: 'Property Name', fieldName: 'PBS_AAAP_Building_Name__c', sortable: true},
            { label: 'Street Address', fieldName: 'PBS_AAAP_Street_Address__c',sortable: true },
            { label: 'City', fieldName: 'PBS_AAAP_City__c',sortable: true },
            { label: 'State', fieldName: 'PBS_AAAP_State__c',sortable: true },
            { label: 'RLP Number', fieldName: 'rlpType',sortable: true },
            { label: 'RLP Type', fieldName: 'awardType',sortable: true },
            { label: 'Offer Status', fieldName: 'PBS_AAAP_Offer_Status__c',sortable: true }
        ];
    }

    connectedCallback() {
        //this.onLoad();
    }

    hasPropData(){
        return this.propList && this.propList.length > 0 ? true : false;
        
    }
 
    handleButtonClick(event) {
        const offId = event.target.dataset.id;
        if (offId) {
            getOfferDetails({ offerId: offId })
                .then(result => {
                    console.log('result ', result);
                    this.offerPropertyId = result.Property__c;
                    this.offerId = result.Id;
                    this.offerStatus = result.PBS_AAAP_Offer_Status__c;
                    console.log('OFFERPROPERTYID: ' + this.offerPropertyId);
                    console.log('OFFERTATUS: ' + this.offerStatus);
                    if (this.offerPropertyId) {
                        getPropertyOfferDetails({ recordId: this.offerPropertyId })
                            .then(data => {
                                this.offerBuildingName = data.PBS_AAAP_Building_Name;
                                this.offerABOAsqft = data.PBS_AAAP_TOTAL_BOMA_USF_OFFERED;
                                console.log('BUILDINGNAME:', this.offerBuildingName);
                                console.log('ABOA:', this.offerABOAsqft);
                                this.navigation(); 
                            })
                            .catch(error => {
                                console.error('Error fetching property details: ', error);
                                this.navigation(); 
                            });
                    }else {
                        //this.navigation();
                        this[NavigationMixin.Navigate]({
                            type: 'standard__webPage',
                            attributes: {
                                url: `/Offer-OfferOptions?offerId=${this.offerId}`
                            }
                            });
                        }
                     })
                    .catch(error => {
                    console.error('Error fetching offer details: ', error);
                    });
        }
    }
    navigation() {
        if ((this.offerPropertyId && this.offerBuildingName && this.offerABOAsqft) || this.offerStatus === 'Closed') {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: `/Offer-OfferOptions?propertyId=${this.offerPropertyId}&offerId=${this.offerId}`
                }
            });
     } else {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `/Offer-OfferOptions?propertyId=${this.offerPropertyId}&offerId=${this.offerId}`
            }
            });
        }
     }

    handleAddProperty() {
        // Redirect to the desired Lightning Community page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/Offer-PropertyOptions' // Adjust the path to your community page
            }
        });
    }

     @track sortedBy;
    @track sortedDirection = 'asc';

    

    get nameSortIcon() {
        return this.sortedBy === 'propertyName' ? (this.sortDirection === 'asc' ? '▲' : '▼') : '';
    }

    sortData(fieldName, direction) {
        this.propList = [...this.propList].sort((a, b) => {
            const aValue = a[fieldName] || '';
            const bValue = b[fieldName] || '';
            return direction === 'asc' ? (aValue > bValue ? 1 : -1) : (aValue < bValue ? 1 : -1);
        });
    }

    get sortIcons() {
        return {
            propertyName: this.sortedBy === 'propertyName' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            street: this.sortedBy === 'street' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            city: this.sortedBy === 'city' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            state: this.sortedBy === 'state' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            rlpnumber: this.sortedBy === 'rlpnumber' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            rlptype: this.sortedBy === 'rlptype' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup',
            offerstatus: this.sortedBy === 'offerstatus' ? (this.sortedDirection === 'asc' ? 'utility:arrowup' : 'utility:arrowdown') : 'utility:arrowup'
        };
    }


    //sortedBy = '';
    sortDirection = 'asc';

    get isAscending(){
        return this.sortDirection === 'asc' ? true : false;
    }

    get isSortedByPropName(){
        return this.sortedBy == 'PBS_AAAP_Building_Name__c' ? true : false;
    }

    get isSortedByStreet(){
        return this.sortedBy == 'PBS_AAAP_Street_Address__c' ? true : false;
    }

    get isSortedByCity(){
        return this.sortedBy == 'PBS_AAAP_City__c' ? true : false;
    }

    get isSortedByState(){
        return this.sortedBy == 'PBS_AAAP_State__c' ? true : false;
    }
    get isSortedByRLPNum(){
        return this.sortedBy == 'Formula_RLP_Num__c' ? true : false;
    }
    get isSortedByRLPType(){
        return this.sortedBy == 'RecordType.Name' ? true : false;
    }
    get isSortedByOfferStatus(){
        return this.sortedBy == 'PBS_AAAP_Offer_Status__c' ? true : false;
    }

    handleSort(event) {
        const fieldName = event.target.dataset.fieldName;
        const direction = this.sortDirection === 'asc' ? 'desc' : 'asc';
        this.sortDirection = direction;
        this.sortedBy = fieldName;
        if(this.sortedBy == 'PBS_AAAP_Building_Name__c'){
            this.sortData('PBS_AAAP_Building_Name__c');
        }
        else if(this.sortedBy == 'PBS_AAAP_Street_Address__c'){
            this.sortData('PBS_AAAP_Street_Address__c');
        }
        else if(this.sortedBy == 'PBS_AAAP_City__c'){
            this.sortData('PBS_AAAP_City__c');
        }
        else if(this.sortedBy == 'PBS_AAAP_State__c'){
            this.sortData('PBS_AAAP_State__c');
        }
        else if(this.sortedBy == 'Formula_RLP_Num__c'){
            this.sortData('Formula_RLP_Num__c');
        }
        else if(this.sortedBy == 'RecordType.Name'){
            this.sortData('RecordType.Name');
        }
        else if(this.sortedBy == 'PBS_AAAP_Offer_Status__c'){
            this.sortData('PBS_AAAP_Offer_Status__c');
        }
    }

    sortData(field) {
        const direction = this.sortedBy === field && this.sortDirection === 'asc' ? 'desc' : 'asc';
        this.propList = [...this.propList].sort((a, b) => {
            const aField = a[field];
            const bField = b[field];

            // Handle null values
            if (!aField && !bField) return 0;
            if (!aField) return 1; // Place null last
            if (!bField) return -1; // Place null last

            let comparison = 0;
            if (aField > bField) {
                comparison = 1;
            } else if (aField < bField) {
                comparison = -1;
            }

            return direction === 'asc' ? comparison : -comparison;
        });
    }

    // Method to handle the click event and open the popup window
    handleClick(){
        this.isModalOpen = true;
        console.log('POPUP'+this.PBS_AAAP_PortalHome_Popup);
    }

    // Function to open the popup window
    newPopup(url) {
        window.open(
            url,
            'popUpWindow',
            'height=650,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=no'
        );
    }
        handleSave(){
            this.isRLPModalOpen = true;
            console.log('POPUP'+this.PBS_Leasing_RLPTypes);
        }
    closeModal(){
        this.isModalOpen = false;
        this.isRLPModalOpen = false;
    }
}