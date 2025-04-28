import { LightningElement, track, wire} from 'lwc';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import DOCUMENT_CATEGORY_FIELD from '@salesforce/schema/RET_Document_Data__c.Document_Category__c';
import DOCUMENT_TYPE_FIELD from '@salesforce/schema/RET_Document_Data__c.Document_Type__c';

import getCaseId from '@salesforce/apex/RET_UploadAttachmentController.getCaseId';
import insertDocumentLinkRecords from '@salesforce/apex/RET_UploadAttachmentController.insertDocumentLinkRecords';
import deleteTheUploadedDocuments from '@salesforce/apex/RET_UploadAttachmentController.deleteTheUploadedDocuments';

export default class RET_UploadAttachment extends NavigationMixin( LightningElement ) {

    leaseNumber;
    @track data = [];
    @track docTypes = [];
    @track categoryTypeDescriptions ;
    @track docDescriptionsData;
    @track docDescriptions = [];
    @track showHelpText = false;
    @track isShowModal = false;
    @track isLoading = false;
    err = false;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.leaseNumber = currentPageReference.state.leaseNumber;
        }
    }

    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA', fieldApiName: DOCUMENT_TYPE_FIELD }) 
    documentDescriptionInfo({ data, error }) {
        if (data) this.docDescriptions = data;
    }

    @wire(getPicklistValues, {recordTypeId: '012000000000000AAA', fieldApiName: DOCUMENT_CATEGORY_FIELD })
    categoryFieldInfo({ data, error }) {
        if (data) this.categoryTypeDescriptions =  data.values;
        
            
    }

    connectedCallback(){
        console.log('Starting connectedCallback(), about to call getCaseId with leaseNumber: ' + this.leaseNumber);
        getCaseId({ leaseNumber: this.leaseNumber })
        .then(result => {
            console.log('getCaseId() retrieved caseId: ' + result);
        })
        .catch(error => {
            console.log(error);
        });
    }

    handleDocTypeChange(event) {
        let id =  event.target.name;
        let currentValue = event.detail.value;
        console.log(event.detail.value , ' +++ ', event.target.value);
        for(var i=0; i < this.data.length; i++){
            if(id == this.data[i].contentDocumentId){
                this.data[i].documentCategory = currentValue;
                let key = this.docDescriptions.controllerValues[currentValue];
                console.log(key);
                this.data[i].docDescriptionsDatas = this.docDescriptions.values.filter(opt => opt.validFor.includes(key));
                console.log(this.data[i].docDescriptionsDatas);
            }
        }
    }

    handleDocDescriptionsChange(event) {
        let id = event.target.name;
        let currentValue = event.detail.value;
        for(var i=0; i < this.data.length; i++){
            if(id == this.data[i].contentDocumentId){
                this.data[i].documentType = currentValue;
            }
        }
    }

    hideModalBox() {  
        this.isLoading = true;
        deleteTheUploadedDocuments({ contentdocumentRecords: this.data })
      .then(result => {
        this.isLoading = false;
          this.isShowModal = false;
          this.data = [];
          this.dispatchEvent(new CustomEvent("fileupload"));
      })
      .catch(error => {
         this.isLoading = false;
          console.log(error);
      });
    }   

    saveModalBox() {
        this.isLoading = true;
        console.log('Files uploaded : ' + JSON.stringify(this.data));
        for (var i = 0; i < this.data.length; i++) {
            console.log('??: ' +this.data[i].documentType);
            
            if (this.data[i].documentCategory == '' || this.data[i].documentCategory == undefined) {
                this.err = true;
                this.showToast('error', 'Error', 'Please Select Attachment Type.');
                this.isLoading = false;
                return;
            } else if (this.data[i].documentType == '' || this.data[i].documentType == undefined) {
                this.err = true;
                this.showToast('error', 'Error', "Please enter an Attachment Description for the  Attachment Type.");
                console.log('ERROR : ');
                this.isLoading = false;
                return;
            }else{
                this.err = false; 
            }
            
        }
        console.log('err ' +this.err);
        if (!this.err) {
            insertDocumentLinkRecords({ leaseNumber: this.leaseNumber, contentdocumentRecords: this.data })
                .then(result => {
                    console.log('this.leaseNumber: ', this.leaseNumber);
                    console.log('result: ' + JSON.stringify(result));
                    this.data = result;
                    console.log('this.data: ', JSON.stringify(this.data));
                    this.isLoading = false;
                    this.showToast('Success', 'Success', 'Documents are uploaded sucessfully.');
                    this.isShowModal = false;
                    window.location.reload();
                })
                .catch(error => {
                    this.isLoading = false;
                    console.log(error);
                    this.showToast('error', 'Error', 'Error uploading documents to the system,  please try again.');
                });
        }
    }

    showToast(variant, title, message){
        const event = new ShowToastEvent({
            variant : variant,
            title:title,
            message: message
        });
        this.dispatchEvent(event);
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        console.log('uploadedFiles: ' + JSON.stringify(uploadedFiles));
        for(let i=0; i<uploadedFiles.length; i++){
            this.data.push({'name': uploadedFiles[i].name,'contentDocumentId':uploadedFiles[i].documentId});
        }
        console.log('uploaded files: ' + JSON.stringify(this.data));
        this.isShowModal = true;
    }
}