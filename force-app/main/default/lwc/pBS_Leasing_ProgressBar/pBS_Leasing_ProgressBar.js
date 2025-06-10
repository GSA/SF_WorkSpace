import { LightningElement, api, wire } from 'lwc';
import getSteps from "@salesforce/apex/PBS_Leasing_ProgressBarController.getSteps";
import getPBS_AAAP_RLP_ObjRecords from "@salesforce/apex/PBS_Leasing_ProgressBarController.getPBS_AAAP_RLP_ObjRecords";
import { createMessageContext, releaseMessageContext, publish } from 'lightning/messageService';
export default class pBS_Leasing_ProgressBar extends LightningElement {
    pageName;
    @api progressBarName = '';
    @api offerId = 'as';
    @api isViewOnly = false;
    steps = [];
    edit = '';
    pbsAAAPRLPRecords;

    context = createMessageContext();
    disconnectedCallback() {
        releaseMessageContext(this.context);
    }
    connectedCallback() {
        this.pageName = window.location.pathname.substring(11);
        /*var encodeHref = encodeURIComponent(window.location.href);
        var href = decodeURIComponent(encodeHref);
        this.offerId = href.substring(href.indexOf("offerId=")+8);
        this.edit = href.substring(href.indexOf("edit=")+5,href.indexOf("&"));*/
        var encodeHref = encodeURIComponent(window.location.href);
        var href = decodeURIComponent(encodeHref);
        this.offerId = href.substring(href.indexOf("offerId=")+8,href.lastIndexOf("&"));
        this.edit = href.substring(href.indexOf("edit=")+5,href.indexOf("&"));
        console.log('getSteps', this.edit);
        
        getSteps({ progressBarName: this.progressBarName })
            .then((data) => {
                console.log('data', data);
                this.steps = data;
                var isStepPassed = true;
                for (var stepNumber in this.steps) {
                    var step = this.steps[stepNumber];
                    var pageURL = step.Page_URL__c;
                    console.log('>>>>>>>>>pageURL>>>>>>>',pageURL);
                    if(pageURL != '#'){
                        var stepURL = new URL(window.location.origin + '/leasing/s' + step.Page_URL__c);
                        console.log('stepURL>>>>>>>',stepURL);
                        var vars = [], hash;
                        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                        for(var i = 0; i < hashes.length; i++)
                        {
                                hash = hashes[i].split('=');                        
                                vars[hash[0]] = hash[1];
                                stepURL.searchParams.set(hash[0],  hash[1]);
                        }
                        if (this.isViewOnly) {
                            console.log('isViewOnly>>>>>>',this.isViewOnly);
                            step.Page_URL__c = '#';
                        } else {
                            step.Page_URL__c = stepURL.href.replace(window.location.origin ,'');
                        }
                    }
                    if (isStepPassed) {
                        step.DeveloperName = 'usa-step-indicator__segment usa-step-indicator__segment--complete';
                    } else {
                        step.DeveloperName = 'usa-step-indicator__segment';
                    }
                    console.log(stepNumber, this.steps.length);
                    var currentPageName = window.location.href;
                    if(currentPageName.endsWith("Offer-M-Eligibility")){
                        currentPageName += '?';
                    }
                    if (currentPageName.includes(pageURL) || (isStepPassed == true && stepNumber == (this.steps.length - 1))) {
                        //step.DeveloperName = 'slds-path__item slds-is-current';
                        step.DeveloperName = 'usa-step-indicator__segment usa-step-indicator__segment--current';
                        isStepPassed = false;
                    }
                    if (step.Label == 'Offer' ) {
                        //step.Page_URL__c = '/leasing/s/Offer-M-Eligibility?edit=true&offerId='+this.offerId+'&propertyId=a05SL000005BVjFYAW'; 
                        step.DeveloperName = 'usa-step-indicator__segment usa-step-indicator__segment--disabled';
                    }
                }
                console.log('this.steps+++++++',this.steps);

                //this.callGetRLPObjRecords();
            })
            .catch((error) => {
                console.log("USAGE Error-->", JSON.stringify(error));
            });
    }
    handleClick(ev) {
        let currentThis = this;
        let urlToRedirect = ev.currentTarget.dataset.url;
        console.log('handleClick',urlToRedirect );
        if(urlToRedirect.includes('/page')){
            console.log('Here check');
            getPBS_AAAP_RLP_ObjRecords({ offerId: this.offerId })
            .then(offerRecord => {
                console.log(offerRecord);
                if(offerRecord.RecordType.Name == 'AAAP'){
                    urlToRedirect = urlToRedirect.replace('page','Offer-M-Eligibility');
                }else{
                    urlToRedirect = urlToRedirect.replace('page','Offer-S-Eligibility');
                }
                console.log(urlToRedirect);
                const event = new CustomEvent('navigatetopage', {
                    detail: { message:urlToRedirect }
                });
                // Dispatch the event
                window.dispatchEvent(event);
                currentThis.dispatchEvent(event);
                console.log('dispatchEvent');
            })
            .catch(error => {
                console.error('Error retrieving PBS_AAAP_RLP__c records', error);
            });
        }else if(urlToRedirect != '#'){
            const event = new CustomEvent('navigatetopage', {
                detail: { message: urlToRedirect }
            });
            // Dispatch the event
            window.dispatchEvent(event);
            this.dispatchEvent(event);
            console.log('dispatchEvent');
        }
    }
    get isNewProgressBar() {
        return true;
    }
    get isAAAPOfferAttachmentPage() {
        console.log('this.pageName>>>>>>>>>>>',this.pageName);
        return this.pageName.startsWith('Offer-M-Attachments');
    }
    get isRSAPAttachmentsPage() {
        return this.pageName.startsWith('Offer-S-Attachments');
    }
    
    // callGetRLPObjRecords() {
    //     getPBS_AAAP_RLP_ObjRecords({ offerId: this.offerId })
    //         .then(data => {
    //             this.pbsAAAPRLPRecords = data.length > 0 ? data[0] : null;
    //             if(this.pbsAAAPRLPRecords != null){
    //                 for (var stepNumber in this.steps) {
    //                     var step = this.steps[stepNumber];
    //                     if (step.Label == 'Offer' ) {
    //                         if(this.pbsAAAPRLPRecords.RecordType.Name == 'AAAP'){
    //                             this.steps[stepNumber].Page_URL__c = this.steps[stepNumber].Page_URL__c.replace('page','Offer-M-Eligibility');
    //                         }else{
    //                             this.steps[stepNumber].Page_URL__c = this.steps[stepNumber].Page_URL__c.replace('page','Offer-S-Eligibility');
    //                         }
    //                         console.log(this.steps[stepNumber].Page_URL__c);
    //                     }
    //                 }
    //             }
    //         })
    //         .catch(error => {
    //             this.pbsAAAPRLPRecords = null;
    //             console.error('Error retrieving PBS_AAAP_RLP__c records', error);
    //         });
    // }
    // get hasRecords() {
    //     return this.pbsAAAPRLPRecords !== null;
    // }
}