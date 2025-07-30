import { LightningElement, api } from 'lwc';
import getPBS_AAAP_Offer_ObjRecords from "@salesforce/apex/PBS_Leasing_ProgressBarController.getPBS_AAAP_Offer_ObjRecords";
export default class PBS_Leasing_OfferPreview extends LightningElement {
    @api offerId = '';
    pbsAAApOfferRecords;
    connectedCallback() {
        if(this.offerId == ''){
            var currentURL = new URL(decodeURIComponent(encodeURIComponent(window.location.href)));
            this.offerId = currentURL.searchParams.get("offerId")
                getPBS_AAAP_Offer_ObjRecords({ offerId: this.offerId })
                .then(data => {
                        this.pbsAAApOfferRecords = data.length > 0 ? data[0] : null;
                        console.log('this.pbsAAApOfferRecords',this.pbsAAApOfferRecords);
                    })
                    .catch(error => {
                        this.pbsAAApOfferRecords = null;
                        console.error('Error retrieving PBS_AAAP_RLP__c records', error);
                    });
        }
    }
}