import { LightningElement, api } from 'lwc';

export default class ModalComponent extends LightningElement {

@api isModalOpen = false;
@api modalContent = '';

closeModal() {
    this.isModalOpen = false;
    const closeEvent = new CustomEvent('close');
    this.dispatchEvent(closeEvent);
}
renderedCallback() {
    if (this.isModalOpen) {
        const container = this.template.querySelector('.modal-content-container');
        container.innerHTML = this.modalContent;  
    }
}
}