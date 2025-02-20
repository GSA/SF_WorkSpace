import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getRelatedContent from '@salesforce/apex/PBS_AAAP_RelatedContentController.getRelatedContent';
import deleteNoteRecord from '@salesforce/apex/PBS_AAAP_RelatedContentController.deleteNoteRecord';
const FIELDS = [
    'PBS_AAAP_Agency_Requirement__c.Id',
    'PBS_AAAP_Agency_Requirement__c.CreatedById'
];

const COLS = [
  { label: 'Title', fieldName: 'Title', type: 'text' },
  { label: 'Content Type', fieldName: 'FileType', type: 'text' },
  { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: { year: 'numeric', month: 'short', day: 'numeric' } },
  { label: 'Created By', fieldName: 'CreatedByName', type: 'text' },
  
  {
    type:"button",
    fixedWidth: 150,
    typeAttributes: {
        label: 'View',
        name: 'view',
        variant: 'brand'
    }
  },
  {
    type:"button",
    fixedWidth: 150,
    typeAttributes: {
        label: 'Edit',
        name: 'edit',
        variant: 'brand'
    }
  },
  {
    type:"button",
    fixedWidth: 150,
    typeAttributes: {
        label: 'Delete',
        name: 'delete',
        variant: 'destructive'
    }
  }
];

export default class pBS_AAAP_Agency_RequirementContentNotes extends LightningElement {
  @api recordId;

  @track relatedData = [];
  @track columns = COLS;
  @track isModalOpen = false;
  content = '';

  @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
  wiredRecord({ error, data }) {
    if (error) {
      console.error(error);
      return;
    }
    if (data) {
      const createdById = getFieldValue(data, 'PBS_AAAP_Agency_Requirement__c.CreatedById');
      getRelatedContent({ recordId: this.recordId })
        .then(result => {
          this.relatedData = result;
        })
        .catch(error => {
          console.error(error);
        });
    }
  }

  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    var noteRecordId = event.detail?.row?.Id;
    switch (action.name) {
      case 'view':
        this.viewFileOrNoteRow(row);
        break;
      case 'edit':
        // Fire the custom event and passing note record id
        const valueChangeEvent = new CustomEvent("updatenote", {
          detail: { value: noteRecordId}
        });        
        this.dispatchEvent(valueChangeEvent);      
        break;
      case 'delete':
       this.deleteContentNote(noteRecordId);
        break;
      default:
        break;
    }
  }

  viewFileOrNoteRow(row) {
    this.isModalOpen = true;
    console.log(row.Id);
    this.content = row.content;
    /*
    this[NavigationMixin.Navigate]({ 
      type:'standard__namedPage',
      attributes:{ 
          pageName:'filePreview'
      },
      state:{ 
          selectedRecordId: row.Id
      }
  })*/
    /*
    const navEvt = new CustomEvent('navtofileornote', {
      detail: { recordId: row.Id, title: row.Title }
    });
    this.dispatchEvent(navEvt);
    */
  }

  @api
  refresh() {
    return refreshApex(this.relatedData);
  }

  deleteContentNote(contentNoteId) {
    deleteNoteRecord({ noteId: contentNoteId })
    .then(result => {
      window.location.reload();
    })
    .catch(error => {
      console.error(error);
    });
  }
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }
}