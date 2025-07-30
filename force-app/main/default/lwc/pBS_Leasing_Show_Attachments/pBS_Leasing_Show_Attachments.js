import { LightningElement, api, track} from 'lwc';
import getColumnsAndRecords from '@salesforce/apex/PBS_Leasing_AttachmentController.getColumnsAndRecords';
import deleteRecord from '@salesforce/apex/PBS_Leasing_AttachmentController.deleteRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PBS_Leasing_Show_Attachments extends LightningElement {
    @api tableName;
    @api offerId = '';
    @api isDisabledDelete = false;
    label;
    columns = [];
    data = [];
    @track sortBy;
    @track sortDirection;

    connectedCallback() {
        var encodeHref = encodeURIComponent(window.location.href);
        var href = decodeURIComponent(encodeHref);
        var currentURL = new URL(decodeURIComponent(encodeURIComponent(window.location.href)));
        if(this.offerId == ''){
            this.offerId = currentURL.searchParams.get("offerId");
        }
        this.callGetColumnsAndRecords();
           
    }
    @api 
    callGetColumnsAndRecords(){
         getColumnsAndRecords({ datatableName: this.tableName, recordId: this.offerId, isDisabledDelete:this.isDisabledDelete})
        .then(result => {
            console.log('result>>>', result);
            this.columns = result.columns;
            this.data = result.records;
            console.log('this.data>>>>>>>>>>>>>>>>>>>>>>',this.data);
            this.label = result.label;
            if(this.label == 'Attachments Already Sent in Previous Sub'){
                this.label = 'Attachments Already Sent in Previous Submissions';
            }
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
    }
}