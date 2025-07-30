import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getPropertyInfoCall from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyInfo';

export default class PBS_LeasingPropertyHome extends NavigationMixin(LightningElement) {
    @track data = [
        { id: '1', propertyName: 'Test1', street: 'Test Street 1', city: 'Test City1', state: 'CA' },
        { id: '2', propertyName: 'Test2', street: 'Test Street 2', city: 'Test City2', state: 'CA' },
        // Add more property data as needed
    ];

    @track propList = [];
    @track sortedBy;
    @track sortedDirection;

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
            { label: 'State', fieldName: 'PBS_AAAP_State__c',sortable: true }
        ];
    }

    connectedCallback() {
        this.onLoad();
    }

    hasPropData(){
        return this.propList && this.propList.length > 0 ? true : false;
    }

    onLoad(){
        getPropertyInfoCall({})
        .then(result => {
            if(result){
                this.propList = result.propList;

                const fieldName = 'PBS_AAAP_Building_Name__c';
                const direction = this.sortDirection === 'asc' ? 'desc' : 'asc';
                this.sortDirection = direction;
                this.sortedBy = fieldName;
                this.sortData(fieldName);
            }
        })
        .catch(error => {
            console.log(error);
        })
    }

    handleButtonClick(event) {
        const propertyId = event.target.dataset.id;
        
        // Redirect to the community page with the selected row ID
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: `/Offer-Location?edit=true&propertyId=${propertyId}` // Adjust the path as needed
            }
        });
    }

    handleAddProperty() {
        // Redirect to the desired Lightning Community page
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/Offer-Location' // Adjust the path to your community page
            }
        });
    }

    handleBack() {
        window.location.href = '/leasing/s/Offer-Home';
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
    }

    sortData(field) {
        const direction = this.sortedBy === field && this.sortDirection === 'asc' ? 'desc' : 'asc';
        //this.sortedBy = field;
        //this.sortDirection = direction;

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
}