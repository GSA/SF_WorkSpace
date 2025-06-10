import { LightningElement, track} from 'lwc';
import insertDocumentLinkRecord from '@salesforce/apex/PBS_Leasing_AttachmentController.insertDocumentLinkRecord';
import updateContentDocumentRecords from '@salesforce/apex/PBS_Leasing_AttachmentController.updateContentDocumentRecords';
import unSavedOfferAttRecords from '@salesforce/apex/PBS_Leasing_AttachmentController.unSavedOfferAttRecords';
import deleteTheUploadedDocuments from '@salesforce/apex/PBS_Leasing_AttachmentController.deleteTheUploadedDocuments';
import getLabel from '@salesforce/apex/PBS_Leasing_AttachmentController.getLabel';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PBS_Leasing_UploadAttachment extends LightningElement {
    pageName;
    offerId;
    selectedAttachmentType;
    @track  data = [];
    @track dataList = [];
    @track recordId
    @track options = [];
    @track value;
    @track showHelpText = false;

      @track isShowModal = false;

      hideModalBox() {  
          deleteTheUploadedDocuments({ contentdocumentRecords: this.data })
        .then(result => {
            this.isShowModal = false;
            this.data = [];
            this.dispatchEvent(new CustomEvent("fileupload"));
        })
        .catch(error => {
            console.log(error);
        });
      }   
      saveModalBox() { 
        console.log('No. of files uploaded : ' , this.data);

        for(var i=0; i < this.data.length; i++){
            if(this.data[i].attachmentType == '' || this.data[i].attachmentType == undefined){
                this.showToast('error','Error','Please Select Attachment Type.');
                return;
            }else if(this.data[i].attachmentType.trim() == 'Other' && this.data[i].attachmentDescription == ''){
                this.showToast('error','Error',"Please enter an Attachment Description for the 'Other' Attachment Type.");
                return;
            }
        }
        updateContentDocumentRecords({ contentdocumentRecords: this.data })
        .then(result => {
            console.log('result>>>',result);
            this.isShowModal = false;
            this.data = [];
            this.dispatchEvent(new CustomEvent("fileupload"));
        })
        .catch(error => {
            console.log(error);
        });
    }
    showToast(variant, title, message){
        const event = new ShowToastEvent({
            variant : variant,
            title:title,
            message: message
        });
        this.dispatchEvent(event);
    }
    otherHandleChange(event){
        let id =  event.target.name;
        let currentValue = event.detail.value;
        for(var i=0; i < this.data.length; i++){
         if(id == this.data[i].offerAttachmentId){
            this.data[i].attachmentDescription = currentValue;
         }
        }
    }
      handleChange(event){
        let id =  event.target.name;
        let currentValue = event.detail.value;
        for(var i=0; i < this.data.length; i++){
         if(id == this.data[i].offerAttachmentId){
            this.data[i].attachmentType = currentValue;
         }
        }
       console.log('this.data ',this.data);
      } 
    connectedCallback(){

        this.pageName = window.location.pathname.substring(11);
        var currentURL = new URL(decodeURIComponent(encodeURIComponent(window.location.href)));
        this.offerId = currentURL.searchParams.get("offerId")
        this.pageName = window.location.pathname.replace('/leasing/s/','');
        console.log('pageName', this.pageName);
        getLabel({pageName: this.pageName})
        .then(result => {
            console.log('resultunSavedOfferAttRecords>>>',result);
            var labelValues = result.split(',');
            console.log('labelValues ',labelValues);
            this.options.push({label:'--None--',value:''});
            labelValues.forEach(currentItem => {
                this.options.push({label:currentItem,value:currentItem});
            });
            console.log('options ', this.options);

        })
        .catch(error => {
            console.log(error);
        });

        unSavedOfferAttRecords({offerId: this.offerId})
        .then(result => {
            console.log('resultunSavedOfferAttRecords>>>',result);
            if(result.length > 0){
                this.data = result;
                this.isShowModal = true;
            }
        })
        .catch(error => {
            console.log(error);
        });

    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        console.log('uploadedFiles>>>>>>>>>>>>>>>>>>>',uploadedFiles);
        for(let i=0; i<uploadedFiles.length; i++){
            this.data.push({'name': uploadedFiles[i].name,'contentDocumentId':uploadedFiles[i].documentId,'attachmentDescription':''
        });
        }
        console.log('this.data>>>>>>>>>>>>>>',this.data);
        this.isShowModal = true;

        console.log('No. of files uploaded : ' , this.data);

        insertDocumentLinkRecord({ offerId: this.offerId, contentdocumentRecords: this.data })
        .then(result => {
            console.log('this.offerId>>>>>>>>>>>>>>>>>>>',this.offerId);
            console.log('result>>>',result);
              this.data = result;
            console.log('this.data>>>', this.data);
        })
        .catch(error => {
            console.log(error);
        })
   
 }
}