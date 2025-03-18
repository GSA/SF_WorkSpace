import { LightningElement, api, track } from 'lwc';
import getTIData from '@salesforce/apex/NCMT_TIReport_Controller.getTIReportData';

export default class NCMT_TI_Report extends LightningElement {
    @api projectid
    @api housingplanid
    @track projectDetails;
    @track loaded=false;
    @track showError=false;
    connectedCallback() {
        //console.log("projectId=="+this.projectId);
        //alert('projectid--'+this.projectId);
        getTIData({ 'housingplanid':this.housingplanid,'projectid': this.projectid })
            .then((data) => {
               
                this.projectDetails= data;
                this.loaded=true;
                console.log('=data===' + JSON.stringify(data));
            })
            .catch((error) => {
                this.showError=true;
                console.log('=error===' + JSON.stringify(error));
            });
    }

    redirectToProject() {
        parent.window.location.href = "/" + this.projectid;
    }
    
    redirectToHousingPlan() {
        parent.window.location.href = "/" + this.housingplanid;
    }

    printPage() {
        window.print();
    }
}