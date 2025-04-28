import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import reviewAttachments from '@salesforce/apex/RET_SubmitAttachmentsController.reviewAttachments';
import submitDocsToGrex from '@salesforce/apex/RET_SubmitAttachmentsController.submitDocumentsToGREX';
export default class RET_SubmitAttachments extends NavigationMixin( LightningElement ) {

    @api leaseNumber;
    @api caseId;
    @api myCase;
    data = [];
    columns = [];
    errors = '';
    error =[];
    isReadyToSubmit = false;
    @track showLoading = false;
    @track isShowModal = false;
    @track infoDetails1 = {};
    @track infoDetails2 = {};
    @track infoDetails3 = {};

    hideModalBox() {  
        this.isShowModal = false;
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.leaseNumber = currentPageReference.state.leaseNumber;
        }
    }

    connectedCallback() {
        console.log('Inside rET_SubmitAttachments connectedCallback(), about to call reviewAttachments()...');
        reviewAttachments({ leaseNumber: this.leaseNumber })
            .then(result => {
                this.isReadyToSubmit = result.success;
                if(this.isReadyToSubmit) {
                    this.myCase = result.myCase;
                    console.log('connectedCallback(), reviewAttachments() result case: ' + JSON.stringify(result.myCase));
                    this.caseId = result.myCase.Id;
                }
            })
            .catch(error => {
                console.log(error);
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error',
                    mode: 'dismissable'
                  });
                  this.dispatchEvent(evt);
            }) 
    }

    handleCancel() {
        const event = new CustomEvent('cancel', {
            detail: { message: 'cancel' }
        });
        this.dispatchEvent(event);
    }

    handleSubmitClick() {
        this.showLoading = true;
        console.log('in handleSubmitClick...');
        this.infoDetails1 = 'Enter the email address of your GSA contact, if you know who that is. This will ensure they are alerted about your document submission. Otherwise, this will go to a group mailbox and may increase the time it takes GSA to respond with any follow-up actions you may be waiting on.';
        this.infoDetails2 = 'If uploading tax documents, include the applicable tax year below. Otherwise, enter any additional comments for the recipient you may have.';
        this.infoDetails3 = 'Select ‘Continue’ if you are ready to submit or ‘Cancel’ to change the documents you want to submit.';

        this.isShowModal = true;
        this.showLoading = false;
    }

    handleContinueClick() {
        this.showLoading = true;
        submitDocsToGrex({ caseId: this.caseId })
        .then(result => {
            
            const evt = new ShowToastEvent({
                title: 'Success',
                message: 'Your documents have been submitted successfully.',
                variant: 'success',
                mode: 'dismissable'
              });
              this.dispatchEvent(evt);
              this.isShowModal = false;
              this.showLoading = false;
              window.location.reload();
        })
        .catch(error => {
            console.log(error);
            const evt = new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error',
                mode: 'dismissable'
              });
              this.dispatchEvent(evt);
              this.showLoading = false;
        })   
    }

}