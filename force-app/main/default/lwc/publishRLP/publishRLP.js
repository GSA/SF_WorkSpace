import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, updateRecord  } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import getAttachments from'@salesforce/apex/PBS_AAAP_PublishRLPController.getAttachments';
const FIELDS = ['PBS_AAAP_RLP__c.PBS_AAAP_STATUS__c'];
export default class PublishRLP extends LightningElement {
    
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
            console.log('Updated Yes'+this.isFromSuccess);
            if(data.fields.PBS_AAAP_STATUS__c.value == 'Replaced' && this.isFromSuccess == false){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:'Replaced RLP can not be published',
                        variant: 'error',
                    }),
                );
                this.dispatchEvent(new CloseActionScreenEvent());
                return;
            }else{

            if(data.fields.PBS_AAAP_STATUS__c.value == 'Posted/Active' && this.isFromSuccess == false){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:'Only RLP with status DRAFT can be published',
                        variant: 'error',
                    }),
                );
            }
                if(this.isFromSuccess == false){
                    getAttachments({ recordId: this.recordId })
                    .then(result => {
                        if(result.length == 0 && this.isFromSuccess == false){
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Error',
                                    message:'Please upload the RLP attachments to publish an RLP',
                                    variant: 'error',
                                }),
                            );
                            this.dispatchEvent(new CloseActionScreenEvent());
                        }else{
                            this.isFromSuccess = true;
                            const fields = {};
                            fields['Id'] = this.recordId;
                            fields['PBS_AAAP_STATUS__c'] =  'Posted/Active';
                            fields['PBS_AAAP_isActive__c'] = true;
                            fields['PBS_AAAP_Canceled_Date__c'] = null;
                            fields['PBS_AAAP_Canceled_Reason__c'] = null;
                            const recordInput = {
                            fields: fields
                            };
                            updateRecord(recordInput).then((record) => {
                                this.isFromSuccess = true;
                                this.dispatchEvent(new CloseActionScreenEvent());
                                
                            this.dispatchEvent(
                                new ShowToastEvent({
                                    title: 'Success',
                                    message:'The RLP is Published successfully.',
                                    variant: 'success',
                                }),
                            );
                            
                            console.log(record);
                            }).catch(error => {
                                console.log(error);
                                this.dispatchEvent(new CloseActionScreenEvent());
                            });
                        }
                    })
                    .catch(error => {
                        console.log(error);
                        this.dispatchEvent(new CloseActionScreenEvent());
                    })
                }
            
            }
        }
    }
}