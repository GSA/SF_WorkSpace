import { LightningElement, api, track } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
import getYestersDay from '@salesforce/apex/PBS_Leasing_GIS_MapController.getYestersDay';
export default class pBS_Leasing_GIS_Map extends LightningElement {    
    //@track height = '500px';
    //@track width  = '100%;';
    yesterdayDate;
    connectedCallback(){
        getYestersDay({})
        .then(result => {
            console.log('result>>>',result);
            this.yesterdayDate = result;
        })
        .catch(error => {
            console.log(error);
        });
    }     
    /*renderedCallback() {
        let mapWidth = this.template.querySelector('.mapId');
        console.log('width ',mapWidth.getBoundingClientRect().width);
        if(mapWidth.getBoundingClientRect().width > 768){
            this.width = '1000px;';
        }else if(mapWidth.getBoundingClientRect().width > 600){ 
            this.width = '520px;';
        }else if(mapWidth.getBoundingClientRect().width > 450){ 
            this.width = '550px;';
        }else{
            this.width = '350px;';
        }
     }*/
}