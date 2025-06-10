import { LightningElement, api,wire } from 'lwc';
import JSZipJSFile from '@salesforce/resourceUrl/JSZipJSFile';
import { loadScript } from 'lightning/platformResourceLoader';
import getAllOfferAttachments from '@salesforce/apex/PBS_Leasing_AttachmentController.getAllOfferAttachments';
import getOfferAttachmentData from '@salesforce/apex/PBS_Leasing_AttachmentController.getOfferAttachmentData';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import AAAP_BUILDING_NAME_FIELD from "@salesforce/schema/PBS_AAAP_Offer__c.PBS_AAAP_Building_Name__c";
import DefaultTestConfigUrl from "@salesforce/resourceUrl/PBS_AAAP_loading_gif_image";
export default class PBS_Leasing_DownloadAllFiles extends LightningElement {
    @api offerId;

    zipLibraryLoaded = false;
    loadingDownload = false;
    customStyle="padding-left: 10px;";
    spinnerImage = DefaultTestConfigUrl;
    connectedCallback() {
        console.log('spinnerImage'+this.spinnerImage);
        loadScript(this, JSZipJSFile)
            .then(() => {
                 console.log('Sucess loading JSZip:');
                this.zipLibraryLoaded = true;
            })
            .catch((error) => {
                console.error('Error loading JSZip:', error);
            });
    }
    @wire(getRecord, {
        recordId: "$offerId",
        fields: AAAP_BUILDING_NAME_FIELD
      })
      offerrecord;
      get buildingName() {
        return getFieldValue(this.offerrecord.data, AAAP_BUILDING_NAME_FIELD);
      }
    async handleDownload(){
        var today = new Date();
        var dd = today.getDate(); 
        var mm = today.getMonth()+1;
        var yyyy = today.getFullYear();
        if(dd<10) {
            dd = '0'+dd
        } 
        if(mm<10) {
            mm = '0'+mm
        } 
        today = mm + '/' + dd + '/' + yyyy;
        var offerBuilding_Name = 'All Files';
        offerBuilding_Name = this.buildingName;
        this.loadingDownload = true;
        this.customStyle = "padding-left: 10px; margin-right: 20px;";
        console.log('JSZip library is not loaded yet'+JSON.stringify(this.offerrecord));
        if (!this.zipLibraryLoaded) {
            this.loadingDownload = false;
            this.customStyle = "padding-left: 10px;";
            console.log('JSZip library is not loaded yet');
            return;
        }
        const zip = new JSZip();
        const attachmentRecords = await getAllOfferAttachments({ offerId: this.offerId });
        if(attachmentRecords.length == 0){
            console.log('No Attachment records found.');
        }else{
            for (const attachmentRecord of attachmentRecords) {
                const fileContent = await getOfferAttachmentData({ offerAttachmentId:attachmentRecord.Id});
                zip.file(`${fileContent.title}.${fileContent.fileExtension}`, fileContent.fileContent, { base64: true });
                
            }
            console.log('attachmentRecords=>'+JSON.stringify(attachmentRecords));
            let fileName = offerBuilding_Name+' - Offer Document Bundle - '+today+'.zip';
            const zipBlob = await zip.generateAsync({ type: 'blob' });
            this.downloadBlob(zipBlob, fileName);
        }
    }
    downloadBlob(blob, filename) {
        this.loadingDownload = false;
        this.customStyle = "padding-left: 10px;";
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = filename;
        link.click();
        URL.revokeObjectURL(link.href);
    }
}