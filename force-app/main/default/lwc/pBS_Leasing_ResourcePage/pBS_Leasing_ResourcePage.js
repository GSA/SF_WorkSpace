import { LightningElement,track,wire } from 'lwc';
import { loadStyle} from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import Info_Map from '@salesforce/resourceUrl/GSA_regions_map';
import getRegions from '@salesforce/apex/PBS_Leasing_OfferOptionsController.getRegions';
import actionShowRLPs from '@salesforce/apex/PBS_Leasing_OfferOptionsController.actionShowRLPs';
import gsa_common from '@salesforce/resourceUrl/gsa_common';

export default class PBS_Leasing_ResourcePage extends NavigationMixin(LightningElement) {

    @track selectedRegion = ''; 
    @track showError = false;
    @track regionOptions = []; 
    mapImageUrl = Info_Map;

    @wire(getRegions)
    wiredRegions({ error, data }) {
        if (data) {
            this.regionOptions = data; 
            
        } else if (error) {
            console.error('Error fetching regions:', error);
        }
    }
    
    handleRegionChange(event) {
        //this.selectedRegion = event.detail.value;
        this.selectedRegion = event.target.value;
       
       
    }

    get imagestyle(){
        return `background: url('${gsa_common}/images/sprite.png') no-repeat center;
                background-size:cover;`
    }

    connectedCallback() {
        Promise.all([
            //loadStyle(this, gsa_common + '/css/styles.css'),
            //loadStyle(this, gsa_common + '/css/demo_page.css'),
            loadStyle(this, gsa_common + '/css/uniform.default.css')
        ])
        .then(() => {
            console.log('CSS Loaded Successfully');
        })
        .catch(error => {
            console.error('Error loading CSS: ', error);
        });
    }
    
    handleViewRLP() {
        if (this.selectedRegion) {
            console.log('actionShowRLPs');
            actionShowRLPs({ selectedRegion: this.selectedRegion})
                            .then(result => {
                                 console.log('actionShowRLPs sucess ',result);
                                 window.location.href = result;
                            })
                            .catch(error => {
                                // Handle error
                                console.log('error: ' + JSON.stringify(error));
                            });
            
        }
        
        console.log('Selected Region:', this.selectedRegion);
    }


}