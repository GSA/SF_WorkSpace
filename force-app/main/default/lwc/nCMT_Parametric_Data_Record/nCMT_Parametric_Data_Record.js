import { LightningElement, api,track} from 'lwc';
import getProjData from '@salesforce/apex/NCMT_ParametricDataRecord_Controller.getProjectData';

export default class NCMT_Parametric_Data_Record extends LightningElement {
    @api projectId
    @track projectDetails;
    @track loaded=false;
    @track showError=false;
    connectedCallback() {
        //console.log("projectId=="+this.projectId);
        //alert('projectid--'+this.projectId);
        getProjData({ 'projectId': this.projectId })
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
        window.location.href = "/" + this.projectId;
    }
    printPage() {
        window.print();
    }
}