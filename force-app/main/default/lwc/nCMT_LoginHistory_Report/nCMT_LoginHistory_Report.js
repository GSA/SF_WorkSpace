import {LightningElement, api, track} from 'lwc';
import getlogdata from '@salesforce/apex/NCMT_LoginHistoryController.retrieveloginhist';
import {exportCSVFile} from 'c/nCMT_utils'
export default class NCMT_LoginHistory_Report extends LightningElement {
    @api numdays
    @track projectDetails;
    @track loaded=false;
    @track showError=false;
    connectedCallback() {
        //console.log("numdays=="+this.numdays);
        //alert('numdays--'+this.numdays);
        getlogdata({ 'numdays': this.numdays })
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
    headers = {
      Name:"Name",
      Username:"Username",
      Email:"Email",
      NCMT_User_Level__c:"NCMT User Level",
      NCMT_UserRegionCode__c:"NCMT User Region",
      LastLoginDate:"LastLoginDate",
      IsActive:"Active"
  }

    printPage() {
        window.print();
    }
    
    downloadCSVFile() { 
      console.log("download triggered.");
      //console.log(this.projectDetails.usrList);
      exportCSVFile(this.headers, this.projectDetails.usrList, "NCMT_UserLog_Report");  
      console.log("download completed.");
   }  

}