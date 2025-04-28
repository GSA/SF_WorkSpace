import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';

export default class RET_DocumentSubmissions extends NavigationMixin( LightningElement ) {

    @api leaseNumber = '';

    errors = [];

    @track exitPrompt = 'Are you sure you want to exit this submission?';

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.leaseNumber = currentPageReference.state.leaseNumber;
        }
    }

    connectedCallback() {
        //Nothing to do on page load currently
    }

    handleExitSubmission() {
        if (confirm(this.exitPrompt)) {
            window.location.href = '/realestatetaxes/s/';
        }
    }

    handleCancel() {
        this.isReadyToSubmit = false;
    }

    handleFileUpload() {
        console.log('In handleFileUpload(), show-attachments querySelector: ' + this.template.querySelector('c-r-e-t_-show-attachments[data-id="RET_Attachments_List"]'));
        this.template.querySelector('c-r-e-t_-show-attachments[data-id="RET_Attachments_List"]').callGetColumnsAndRecords();
        console.log('handleFileUpload() done!');
    }

}