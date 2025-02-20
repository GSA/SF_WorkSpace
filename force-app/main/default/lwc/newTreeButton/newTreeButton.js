import { LightningElement, wire, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import saveRecord from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getsaveNewrecord';
import getProjectName from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getProjectName';
import getrecordTypeName from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getrecordTypeName';
import getParentTree from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getParentTree';
import getRecordInformation from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getRecordInformation';
import getCheck from '@salesforce/apex/NCMT_NewTreeButton_Ctrl.getCheck';
import { CloseActionScreenEvent} from 'lightning/actions';

import { NavigationMixin } from 'lightning/navigation';

export default class NewTreeButton extends NavigationMixin(LightningElement) {
    @api recordId;
    @api branchName;
    @api dsc;
    @api projectName;
    @api recordTypeName;
    @api parentTree;
    @api check;
    saveVisible=true;


    @wire(getProjectName, {recordId: '$recordId'})
    wiredProjectName({ error, data}){
        if (data){
            this.projectName=data;
        }else if(error){
            console.error(error);
        }
        console.log(this.projectName);
    }

    @wire(getrecordTypeName, {recordId: '$recordId'})
    wiredRecordTypeName({ error, data}){
        if (data){
            this.recordTypeName=data;
        }else if(error){
            console.error(error);
        }
        console.log(this.recordTypeName);
    }

    @wire(getParentTree, { recordId: '$recordId'})
    wiredParentTree({error, data}){
        if(data){
            this.parentTree=data;
        }else if(error){
            console.error(error);  
            }
        console.log(this.parentTree);    
        }
        
        @wire(getCheck, { recordId: '$recordId'})
        wiredCheck({error, data}){
          
            if(data){
                if(data=== true){
                    this.check=true;
                    console.log('truecheck'); 
                }else{
                    this.check=false;
                }
               
            }else if(error){
                console.error(error);  
                }
            console.log(this.check);    
            }    
    @wire(getRecordInformation, {recordId: '$recordId'})
    wiredRecordId({error, data}){}

    handleBranchNameChange(event){
        this.branchName=event.target.value;
        console.log(this.branchName);
    }
    handleDscChange(event){
        this.dsc=event.target.value;
        console.log(this.dsc);
    }
    handleCheckChange(event){
        this.check=event.target.checked;
    }
    handleSave(event){
this.saveVisible=false;
        saveRecord({
            projectName:this.branchName,
            recordId:this.recordId,
            dsc: this.dsc,
            branchName: this.branchName,
            check:this.check
        })
        .then(result=>{
            const event = new ShowToastEvent({
                title: 'New Tree created',
                message:'New Tree Structure created successfully',
                variant: 'success'
            });
        this.dispatchEvent(event);


        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId: result,
                objectApiName: 'NCMT_Tree_structure__c',
                actionName: 'view'
            }
});
        })
        .catch(error=>{
            const event=new ShowToastEvent({
                title:'Error',
                message:'Error creationg Tree. Please contact your System Admin',
                variant:'error'
            });
            this.dispatchEvent(event);
        });
       
    }
    
    handleSaveNew(event){
        saveRecord({
            projectName:this.branchName,
            recordId:this.recordId,
            dsc: this.dsc,
            branchName: this.branchName,
            check:this.check
        })
        .then(result=>{
            const event = new ShowToastEvent({
                title: 'Another New Tree created',
                message:'New Tree Structure created successfully',
                variant: 'success'
            });
            this.branchName='';
            this.dsc='';
        this.dispatchEvent(event);

        })
        .catch(error=>{
            const event=new ShowToastEvent({
                title:'Error',
                message:'Error creationg Tree. Please contact your System Admin',
                variant:'error'
            });
            this.dispatchEvent(event);
        });
    } 
    
    handleCancel(event){
        /*this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
                recordId: this.recordId,
                objectApiName: 'NCMT_Tree_structure__c',
                actionName: 'view'
            }
});*/
this.dispatchEvent(new CloseActionScreenEvent());
    }
    }