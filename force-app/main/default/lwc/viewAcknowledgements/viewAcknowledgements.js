import { LightningElement,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ViewAcknowledgements extends NavigationMixin(LightningElement) {
       
    recordId;
    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        
        
         let url =  '/apex/PBS_AAAP_PreviewAck?offerId=' + this.currentPageReference.state.recordId;
      
          this[NavigationMixin.GenerateUrl]({
              type: 'standard__webPage',
              attributes: {
                  url: url
              }
          }).then(vfURL => {
              window.open(vfURL);
              this.dispatchEvent(new CloseActionScreenEvent());
          });
          
    
    }

}