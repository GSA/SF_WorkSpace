import { LightningElement,wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ViewOfferForms extends NavigationMixin(LightningElement) {
       
    recordId;
    @wire(CurrentPageReference)
    currentPageReference;

    connectedCallback() {
        this.recordId = this.currentPageReference.state.recordId;
    }

}