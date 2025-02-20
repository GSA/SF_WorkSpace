import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
const FIELDS = ['PBS_AAAP_RLP__c.PBS_AAAP_STATUS__c'];

export default class CancelRLP extends LightningElement {

    @api recordId;
    isShowCanceledFields = false;
    isFromSuccess = false;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message,
                    variant: 'error',
                }),
            );
            this.dispatchEvent(new CloseActionScreenEvent());
        } else if (data) {
            if(data.fields.PBS_AAAP_STATUS__c.value != 'Posted/Active' && this.isFromSuccess == false){
                this.dispatchEvent(
                    new ShowToastEvent({        
                        title: 'Error',
                        message:'Only RLPs with status POSTED/ACTIVE can be canceled',
                        variant: 'error',
                    }),
                );
                this.dispatchEvent(new CloseActionScreenEvent());
            }else{
                if(this.isFromSuccess == false){
                    this.isShowCanceledFields = true;
                }
            }
        }
    }
    closeModal(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleSubmit(){
        this.isFromSuccess = true;
    }
handleSuccess(event) {
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message:'The RLP is Canceled successfully.',
                        variant: 'success',
                    }),
                );
        //this.accountId = event.detail.id;
    }
}