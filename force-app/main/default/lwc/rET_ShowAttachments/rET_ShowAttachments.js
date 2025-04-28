import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

import getColumnsAndRecords from '@salesforce/apex/RET_ShowAttachmentsController.getColumnsAndRecords';
import deleteRecord from '@salesforce/apex/RET_ShowAttachmentsController.deleteRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RET_ShowAttachments extends NavigationMixin( LightningElement ) {

    @api tableName;
    @api leaseNumber = '';
    @api isDisabledDelete = false;
    label;
    columns = [];
    data = [];
    @track sortBy;
    @track sortDirection;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.leaseNumber = currentPageReference.state.leaseNumber;
            console.log('leaseNumber: ' + this.leaseNumber);
        }
    }

    connectedCallback() {
        this.callGetColumnsAndRecords();
    }

    @api 
    callGetColumnsAndRecords(){
         getColumnsAndRecords({ datatableName: this.tableName, leaseNumber: this.leaseNumber, isDisabledDelete:this.isDisabledDelete})
        .then(result => {
            console.log('getColumnsAndRecords() result: ' + JSON.stringify(result));
            this.columns = result.columns;
            this.data = result.records;
            this.label = result.label;
        })
        .catch(error => {
            console.log(error);
        });
    }

    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }

    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    }    

    handleRowAction(event) {
        console.log('handleRowAction');
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log(row);
        switch (actionName) {
            case 'VIEW FILE':
                window.open(row.PreviewLink, '_blank');
                break;
            case 'DELETE FILE':
                this.deleteAttachmentRecord(row.Id);
                break;
            default:
        }
    }

    deleteAttachmentRecord(recordId) {
        console.log('deleteAttachmentRecord ', recordId);
        deleteRecord({recordId: recordId })
        .then(result => {
            console.log('deleteRecord');
             this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Attachment Deleted Successfully.',
                    variant: 'success'
                })
             );

            this.callGetColumnsAndRecords();
        })
        .catch(error => {
            console.log(error);
        });
        setTimeout(() => {
            window.location.reload();   
        },  3000);
    }

    renderedCallback() {
        const style = document.createElement('style');
        style.innerText = `.slds-scrollable_y {
          max-height: 300px !important;
        }`;
        this.template.querySelector('lightning-datatable')?.appendChild(style);
    }

    get dataHasRecords(){
        return this.data.length > 0;
    }
}