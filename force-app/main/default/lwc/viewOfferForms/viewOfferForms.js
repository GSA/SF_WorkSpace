import { LightningElement,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ViewOfferForms extends NavigationMixin(LightningElement) {
       
    recordId;
    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        
        console.log( 'Param===> ' + this.currentPageReference.state.recordId );
        
         let url =  '/apex/PBS_AAAP_PreviewOfferPage?offerId=' + this.currentPageReference.state.recordId;
      
         console.log('URL===> ' + url);   
         
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