import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import getGisConfig from '@salesforce/apex/PBS_Leasing_PropertyController.getGisConfig';
import createPropertyRecord from '@salesforce/apex/PBS_Leasing_PropertyController.createPropertyRecord';
import updateOfferRecord from '@salesforce/apex/PBS_Leasing_PropertyController.updateOfferRecord';
import getPropertyDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyDetails';
import getPropertyOfferDetails from '@salesforce/apex/PBS_Leasing_PropertyController.getPropertyOfferDetails';
import saveProperty from '@salesforce/apex/PBS_Leasing_PropertyController.saveProperty';
import Info_Icon from '@salesforce/resourceUrl/Info_Icon';
const ARCGIS_CSS = 'https://js.arcgis.com/4.23/esri/themes/light/main.css';
const ARCGIS_JS = 'https://js.arcgis.com/4.23/init.js';

export default class Propertylocation extends NavigationMixin(LightningElement) {

    @track showEsriMessage = false;
    @track esriMessage = '';
    @track showlatitude = false;
    @track floodFlag = false;
    @track seismicFlag = false;
    @track validationError = false;
    @track addressSuggestions = [];
    @track FormatedSuggestions = [];
    @track firstSuggestion = '';
    @track propertyName;
    @track propertyAddress = '';
    @track searchText = '';
    @track updateBoth = false;
    @track streetViewVariant = 'neutral';
    @track satelliteViewVariant = 'neutral';
    @track floodLayerVariant = 'neutral';
    @track seismicLayerVariant = 'neutral';
    @track propertyDetails = {};
    @track propertyRecordDetails = {};
    @track offerDetails = {};
    @track address;
    @track newAddress;
    @track showMap;
    @track isConfirm = false;
    @track isShowMap = false;
    @track isloaded = false;
    @track showbtn = false;
    @track street = '';
    @track city = '';
    @track state = '';
    @track country = '';
    @track county = '';
    @track mapClick = false;
    @track addresscounty = '';
    @track zipCode = '';
    @track latitude = '';
    @track longitude = '';
    @track coordinates;
    @track rlpType = '';
    @track offerStatus = '';
    @track objectType = 'Property';
    @track isaddrdata = false;
    @track showmapHide = false;
    @track addrdata = [ ];
    pageName;
    infoIconImage = Info_Icon;
    redirectURL;
    @api propertyId;
    @api offerId;
    @track newPropId;
    @track isNewOffer = false;

    PageURL;
    @track validationPageName = 'Offer-Location';
    map;
    view;
    seismicLayerActive = false;
    saveActionName = '';
    navigateURL = '';
    errors = '';
    addressSelect = false;
    saveProgressBar = false;
    showSuggestions = false;
    locator = 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer';
    isMapInitialized = false;
    arcgisLoaded = false;
    JSloaded = false;
    streetViewActive = true;   // Street view active by default
    satelliteViewActive;
    floodLayerVisible = false;
    seismicLayerVisible = false;
    helpText = `Tips for establishing your building address and location:<br/><br/><table><tr><td>1.</td><td>Begin entering your building address and click on the provided autocomplete option that matches your building’s address. If none are presented that match your location, finish typing the full address then click the Submit link next to the field.<br><br></td></tr><tr><td>2.</td><td>If the map plots a location that is not correct, but the full address is stated correctly in the #3 Building Address field, click on the link to manually enter the latitude and longitude then click the Submit link after entering the correct information. (Example: Latitude 30.123456, Longitude -70.123456)<br><br></td></tr><tr><td>3.</td><td>If the above solutions do not result in an accurate location, you can manually navigate the map on the page and double click on your building within the map to place a marker on the location of your building. Note that the address that populates may not be precise or formatted correctly, but this can be remedied at a later date. It is more important to have an accurate location established up front.<br><br></td></tr><tr><td>4.</td><td>Use the street address of the building you are proposing to lease. Do not use the mailing address of a different location, a street corner, the building name, or some other description such as a post office box number.</td></tr></table>`;
    gisConfig = {};
    layers = {};
    esriModules = {};
    suggestions = [];
    @api isHelpModalOpen = false;
    esriJsInitialized = false; // Flag to check if ArcGIS is already initialized
    mapView; // Variable to hold the map view
    SF_Label = {};
    esriconfig = {};
    editMode;
    //Getting SF_Label data
    @track isShowModal = false;
    @track activeLayer = '';
    hideModalBox() {
        this.isShowModal = false;
    }
    get columns() {
        return [

            { label: 'Street', fieldName: 'street' },
            { label: 'City', fieldName: 'city' },
            { label: 'State', fieldName: 'state' },
            { label: 'ZipCode', fieldName: 'zipCode' },
            { label: 'County', fieldName: 'county' },
            { label: 'Latitude', fieldName: 'latitude' },
            { label: 'Longitude', fieldName: 'longitude' },
            {
                label: '',
                type: 'button',
                initialWidth: 100,
                typeAttributes: {
                    label: 'Confirm Address',
                    name: 'confirm_address',
                    variant: 'brand',
                    class: 'btn-dt'
                }
            }
        ];
    }
    @wire(getGisConfig)
    wiredConfig({ error, data }) {
        if (data) {
            this.SF_Label = {
                urlPrefix: data.myGisUrlPrefix,
                locatorUrl: data.myGisLocatorUrl,
                locator: {
                    WORLD: data.myGisLocator
                },
                gisToken: data.myGisToken
            };
            console.log('SF Label:', this.SF_Label);
            console.log('SF Locator URL:', this.SF_Label.locatorUrl);
            console.log(this.SF_Label.locator.WORLD);
            console.log(this.SF_Label.gisToken);
        } else if (error) {
            console.error('Error fetching GIS config:', error);
        }
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.propertyId = currentPageReference.state.propertyId;
            this.offerId = currentPageReference.state.offerId;
            if (this.propertyId) {
                this.showbtn = true;
                this.showmapHide = true;
                getPropertyDetails({ proId: this.propertyId })
                    .then(result => {
                        console.log('result ', result);
                        this.propertyDetails = result;
                        this.propertyRecordDetails = result;
                        this.propertyName = result.PBS_AAAP_Building_Name__c;
                        this.address = result.PBS_AAAP_Street_Address__c;
                        this.address = result.PBS_AAAP_User_Defined_Address__c;
                        this.city = result.PBS_AAAP_City__c;
                        this.state = result.PBS_AAAP_State__c;
                        this.county = PBS_AAAP_County__c;
                        this.zipCode = PBS_AAAP_ZipCode__c;
                        this.latitude = PBS_AAAP_X_CO_ORD__c;
                        this.longitude = PBS_AAAP_Y_CO_ORD__c;
                        this.getlatlong(address);
                    })
                    .catch(error => {
                        // Handle error
                    });
            }
            console.log('PropertyId Page reference ', this.propertyId);

            let edit = currentPageReference.state.edit;
            console.log('edit', (edit != undefined));
            if (edit != undefined) {
                this.editMode = (edit == 'true' ? true : false);
            } else {
                this.editMode = true;
            }
        }
    }
    //Getting ESRI libraries
    connectedCallback() {

        this.pageName = window.location.pathname.substring(11);
        this.PageURL = decodeURIComponent(encodeURIComponent(window.location.origin));
        var href = window.location.href;
        //Added for check
        if (this.propertyId && this.propertyId != undefined) {
            getPropertyOfferDetails({ recordId: this.propertyId })
                .then(result => {
                    console.log('NEWresult ', result);
                    console.log('NEWJSONSTRING', JSON.stringify(result));
                    this.propertyDetails = result;
                    this.propertyRecordDetails = this.mapWrapperFields(result);
                    console.log('PROPERTYDETAILSBEFOREUPDATE', JSON.stringify(this.propertyRecordDetails));
                    this.propertyName = result.PBS_AAAP_Building_Name;
                    this.address = result.PBS_AAAP_Street_Address;
                    this.address = result.PBS_AAAP_User_Defined_Address;
                    this.latitude = result.PBS_AAAP_X_CO_ORD;
                    this.longitude = result.PBS_AAAP_Y_CO_ORD;
                    this.county = result.PBS_AAAP_County;
                    if (this.address === null || this.address === undefined && (result.PBS_AAAP_Street_Address != undefined && result.PBS_AAAP_City != undefined && result.PBS_AAAP_State != undefined && result.PBS_AAAP_ZipCode != undefined)) {
                        this.address = result.PBS_AAAP_Street_Address + ', ' + result.PBS_AAAP_City + ', ' + result.PBS_AAAP_State + ', ' + result.PBS_AAAP_ZipCode + ', USA';
                    }
                    
                    this.isNewOffer = result.isNewFlag;
                    if(result.PBS_AAAP_X_CO_ORD == undefined && result.PBS_AAAP_Y_CO_ORD == undefined){
                        this.isConfirm = false;
                    }else{
                        this.isConfirm = true;
                    }
                })
                .catch(error => {
                    // Handle error
                });
        }
        if (this.offerId && this.offerId != undefined) {
            getPropertyOfferDetails({ recordId: this.offerId })
                .then(result => {
                    console.log('NEWOFFERresult ', result);
                    console.log('NEWOFFERJSONSTRING', JSON.stringify(result));

                    this.offerDetails = this.mapWrapperFields(result);
                    this.offerDetails['Property__c'] = result.offerPropertyId;
                    this.offerDetails['PBS_AAAP_Building_Common_Area_Factor__c'] = result.PBS_AAAP_Building_Common_Area_Factor;
                    console.log('NEWOFFERDETAILSBEFOREUPDATE', JSON.stringify(this.offerDetails));
                    this.isNewOffer = result.isNewFlag;
                    this.rlpType = result.PBS_RLPORSolicitation_Number;
                    this.offerDetails['PBS_AAAP_County__c'] = result.PBS_AAAP_County;
                    this.propertyRecordDetails['PBS_AAAP_County__c'] = result.PBS_AAAP_County;
                    this.latitude = result.PBS_AAAP_X_CO_ORD;
                    this.longitude = result.PBS_AAAP_Y_CO_ORD;
                    this.county = result.PBS_AAAP_County;
                    this.offerStatus = result.PBS_AAAP_Offer_Status;
                    this.address = result.PBS_AAAP_User_Defined_Address;
                    
                    if ((this.address === null || this.address === undefined || this.address === '') && (result.PBS_AAAP_Street_Address != undefined && result.PBS_AAAP_City != undefined && result.PBS_AAAP_State != undefined && result.PBS_AAAP_ZipCode != undefined)) {

                        this.address = result.PBS_AAAP_Street_Address + ', ' + result.PBS_AAAP_City + ', ' + result.PBS_AAAP_State + ', ' + result.PBS_AAAP_ZipCode + ', USA';
                    }
                    this.propertyName = result.PBS_AAAP_Building_Name;

                })
                .catch(error => {
                    // Handle error
                });
        }
        
        this.template.addEventListener('click', this.handleClick.bind(this));

    }


    handleClick(event) {
        this.showSuggestions = false;
        const target = event.target;

        if (target.dataset.view === 'street') {
            this.setView('topo-vector');
        } else if (target.dataset.view === 'satellite') {
            this.setView('hybrid');
        } else if (target.dataset.layer === 'flood') {
            this.setView('flood');
        } else if (target.dataset.layer === 'seismic') {
            this.setView('seismic');
        }
    }
    service = {
        setView(view) {

        }
    };

    setView(view) {
        this.service.setView(view);
        const streetViewElement = this.template.querySelector('[data-view="street"]');
        const satelliteViewElement = this.template.querySelector('[data-view="satellite"]');
        const FloodViewElement = this.template.querySelector('[data-layer="flood"]');
        const SeiemicViewElement = this.template.querySelector('[data-layer="seismic"]');
        if (streetViewElement && satelliteViewElement) {
            if (view === 'hybrid') {
                streetViewElement.style.fontWeight = 'normal';
                streetViewElement.style.backgroundColor = '#ffffff';
                satelliteViewElement.style.fontWeight = 'bold';
                satelliteViewElement.style.backgroundColor = 'silver';
            } else if (view === 'topo-vector') {
                streetViewElement.style.fontWeight = 'bold';
                streetViewElement.style.backgroundColor = 'silver';
                satelliteViewElement.style.fontWeight = 'normal';
                satelliteViewElement.style.backgroundColor = '#ffffff';
            }
        }
        else {
            console.error('Elements not found!');
        }

        if (FloodViewElement && SeiemicViewElement) {
            if (view === 'seismic') {
                if (this.activeLayer === 'seismic') {
                    SeiemicViewElement.style.fontWeight = 'normal';
                    SeiemicViewElement.style.backgroundColor = '#ffffff';
                    this.activeLayer = '';
                }
                else {
                    FloodViewElement.style.fontWeight = 'normal';
                    FloodViewElement.style.backgroundColor = '#ffffff';
                    SeiemicViewElement.style.fontWeight = 'bold';
                    SeiemicViewElement.style.backgroundColor = 'silver';
                    this.activeLayer = 'seismic';
                }
            } else if (view === 'flood') {
                if (this.activeLayer === 'flood') {
                    FloodViewElement.style.fontWeight = 'normal';
                    FloodViewElement.style.backgroundColor = '#ffffff';
                    this.activeLayer = '';

                }
                else {
                    FloodViewElement.style.fontWeight = 'bold';
                    FloodViewElement.style.backgroundColor = 'silver';
                    SeiemicViewElement.style.fontWeight = 'normal';
                    SeiemicViewElement.style.backgroundColor = '#ffffff';
                    this.activeLayer = 'flood';
                }
            }
            console.log('LAYER' + this.activeLayer);
        }
        else {
            console.error('Layers not found!');
        }


    }

    handleInputChange(event) {
        const field = event.target.name;
        
        console.log('PropertyRecordDetails', this.propertyRecordDetails);
        if (field === 'propertyName') {
            this.propertyName = event.target.value;

            this.propertyRecordDetails[event.target.fieldName] = event.target.value;
            this.offerDetails[event.target.fieldName] = event.target.value;
            this.addressSelect = false;
        } else if (field === 'propertyAddress') {
            const inputValue = event.target.value;
            this.address = inputValue;
            this.propertyAddress = event.target.value;
            this.isConfirm = false;
            this.propertyRecordDetails[event.target.fieldName] = event.target.value;
            this.offerDetails[event.target.fieldName] = event.target.value;
            this.addressSelect = false;
            console.log(this.propertyAddress);
            console.log(event.target.value);
            this.searchText = event.target.value;
            let config = this.SF_Label;
            let map = this.map;
            let locator = this.locator;
            let addsuggestions = [];
            console.log('Config is', config);
            if (this.searchText.length >= 3) { // Suggest after 3 characters
                let params = {
                    text: this.searchText,
                    categories: ["Subaddress", "Point Address", "Street Address"],
                    minCharacters: 4,
                    maxSuggestions: 10
                };

                return new Promise((resolve, reject) => {

                    require(['esri/identity/IdentityManager', 'esri/tasks/Locator'], (IdentityManager, Locator) => {

                        IdentityManager.registerToken({
                            server: config.urlPrefix,
                            token: config.gisToken,

                        });
                        new Locator(
                            config.locatorUrl
                        )
                            .suggestLocations(params)

                            .then((suggestions) => {
                                resolve(suggestions);
                                console.log('SUGGESTION IS:', suggestions);
                                this.addressSuggestions = suggestions.map(suggestion => suggestion.text);
                                this.FormatedSuggestions = JSON.parse(JSON.stringify(this.addressSuggestions));
                                this.firstSuggestion = this.FormatedSuggestions[0];
                                console.log('Formatted Suggestions:', this.FormatedSuggestions[0]);
                                if (this.addressSuggestions.length > 0) {
                                    this.showSuggestions = true;
                                }
                                else {
                                    this.showSuggestions = false;
                                }
                            })

                            .catch(function (err) {
                                console.log('ERROS IS:', err);
                                reject(err);
                            });


                    });
                });

            } else {
                this.suggestions = [];
                console.log('inside else Error fetching suggestions:', error);
            }
        }
    }

    hasAddrData() {
        return this.addrdata && this.addrdata.length > 0 ? true : false;
    }
    extractAddressDetails(fullAddress) {
        // Split the address into parts by commas and spaces
        const addressParts = fullAddress.split(',');

        if (addressParts.length >= 3) {
            // Extract city from the second part
            if(addressParts.length === 3)
            {
                this.street = addressParts[0].trim();
                this.city = addressParts[1].trim();
                const stateZip = addressParts[2].trim().split(/\s+/); 
                if(stateZip.length >= 2)
                {
                    this.state = stateZip[0].trim();
                    this.zipCode = stateZip[1].trim();
                }
            }
            else{
            this.street = addressParts[0].trim();
            this.city = addressParts[1].trim();
            this.state = addressParts[2].trim();
            this.zipCode = addressParts[3].trim();
            }
        }
        this.propertyRecordDetails['PBS_AAAP_State__c'] = this.state;
        this.propertyRecordDetails['PBS_AAAP_ZipCode__c'] = this.zipCode;
        this.propertyRecordDetails['PBS_AAAP_City__c'] = this.city;
        this.propertyRecordDetails['PBS_AAAP_Country__c'] = 'United States';
        this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.street;
        this.propertyRecordDetails['PBS_AAAP_User_Defined_Address__c'] = this.street + ', ' + this.city + ', ' + this.state + ', ' + this.zipCode + ', USA';
        this.offerDetails['PBS_AAAP_State__c'] = this.state;
        this.offerDetails['PBS_AAAP_ZipCode__c'] = this.zipCode;
        this.offerDetails['PBS_AAAP_City__c'] = this.city;
        this.offerDetails['PBS_AAAP_Country__c'] = 'United States';
        this.offerDetails['PBS_AAAP_Street_Address__c'] = this.street;
        this.offerDetails['PBS_AAAP_User_Defined_Address__c'] = this.street + ', ' + this.city + ', ' + this.state + ', ' + this.zipCode + ', USA';
        
        
        
        console.log('PropertyRecordDetails', this.offerDetails);
        // Log the extracted values for debugging
        console.log('City:', this.city);
        console.log('State:', this.state);
        console.log('Zip Code:', this.zipCode);
        console.log('Country:', this.country);
    }
    extractnewAddressDetails(fullAddress) {
        // Split the address into parts by commas and spaces
        const addressParts = fullAddress.split(',');

        if (addressParts.length >= 4) {
            // Extract city from the second part
            this.street = addressParts[0].trim();
            this.city = addressParts[1].trim();
            this.state = addressParts[2].trim();
            this.zipCode = addressParts[3].trim();
        }
        this.propertyRecordDetails['PBS_AAAP_State__c'] = this.state;
        this.propertyRecordDetails['PBS_AAAP_ZipCode__c'] = this.zipCode;
        this.propertyRecordDetails['PBS_AAAP_City__c'] = this.city;
        this.propertyRecordDetails['PBS_AAAP_Country__c'] = 'United States';
        this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.street;
        this.propertyRecordDetails['PBS_AAAP_User_Defined_Address__c'] = this.street + ', ' + this.city + ', ' + this.state + ', ' + this.zipCode + ', USA';
        this.offerDetails['PBS_AAAP_State__c'] = this.state;
        this.offerDetails['PBS_AAAP_ZipCode__c'] = this.zipCode;
        this.offerDetails['PBS_AAAP_City__c'] = this.city;
        this.offerDetails['PBS_AAAP_Country__c'] = 'United States';
        this.offerDetails['PBS_AAAP_Street_Address__c'] = this.street;
        this.offerDetails['PBS_AAAP_User_Defined_Address__c'] = this.street + ', ' + this.city + ', ' + this.state + ', ' + this.zipCode + ', USA';
       
       
        console.log('PropertyRecordDetails', this.propertyRecordDetails);
        // Log the extracted values for debugging
        console.log('City:', this.city);
        console.log('State:', this.state);
        console.log('Zip Code:', this.zipCode);
        console.log('Country:', this.country);
    }

    getCoordinates(address) {
        const geocodeUrl = 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer/findAddressCandidates';
        const apiKey = this.SF_Label.gisToken; // Get an API key from ESRI if you don't have one

        fetch(`${geocodeUrl}?SingleLine=${address}&f=json&outFields=location&token=${apiKey}`)
            .then(response => response.json())
            .then(data => {
                console.log('DATA IS:', data);
                if (data.candidates && data.candidates.length > 0) {
                    const location = data.candidates[0].location;
                    this.coordinates = {
                        latitude: location.y,
                        longitude: location.x,
                    };
                    console.log('Latitude Is:', this.coordinates.latitude);
                    console.log('Longitutde Is:', this.coordinates.longitude);
                    this.propertyRecordDetails['PBS_AAAP_X_CO_ORD__c'] = this.coordinates.latitude;
                    this.propertyRecordDetails['PBS_AAAP_Y_CO_ORD__c'] = this.coordinates.longitude;
                    this.offerDetails['PBS_AAAP_X_CO_ORD__c'] = this.coordinates.latitude;
                    this.offerDetails['PBS_AAAP_Y_CO_ORD__c'] = this.coordinates.longitude;
                    this.handleCountySelection(this.coordinates.latitude, this.coordinates.longitude);

                } else {
                    console.error('No candidates found for this address.');
                }
            })
            .catch(error => {
                console.error('Error fetching coordinates:', error);
            });
    }
    getlatlong(address) {
        const geocodeUrl = 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer/findAddressCandidates';
        const apiKey = this.SF_Label.gisToken; // Get an API key from ESRI if you don't have one

        fetch(`${geocodeUrl}?SingleLine=${address}&f=json&outFields=location&token=${apiKey}`)
            .then(response => response.json())
            .then(data => {
                console.log('DATA IS:', data);
                if (data.candidates && data.candidates.length > 0) {
                    const location = data.candidates[0].location;
                    this.coordinates = {
                        latitude: location.y,
                        longitude: location.x,

                    };
                    console.log('Latitude Is:', this.coordinates.latitude);
                    console.log('Longitutde Is:', this.coordinates.longitude);
                    this.propertyRecordDetails['PBS_AAAP_X_CO_ORD__c'] = this.coordinates.latitude;
                    this.propertyRecordDetails['PBS_AAAP_Y_CO_ORD__c'] = this.coordinates.longitude;
                    this.offerDetails['PBS_AAAP_X_CO_ORD__c'] = this.coordinates.latitude;
                    this.offerDetails['PBS_AAAP_Y_CO_ORD__c'] = this.coordinates.longitude;
                    this.fetchCounty(this.coordinates.latitude, this.coordinates.longitude);
                    this.addrow();
                } else {
                    console.error('No candidates found for this address.');
                }
            })
            .catch(error => {
                console.error('Error fetching coordinates:', error);
            });
    }
    renderedCallback() {

        console.log('Map Initialized Is:', this.isMapInitialized);
        console.log('AddressSelected Is:', this.addressSelect);
        console.log('Inside Reender Property Id:', this.propertyId);
        console.log('Inside Reender Address Is:', this.address);
        console.log('Inside Reender SFLABEL Is:', this.SF_Label);
        this.isloaded = true;
        Promise.all([
            loadScript(this, ARCGIS_JS),
            loadStyle(this, ARCGIS_CSS)
        ])
            .then(() => {
                console.log('RCGIS Loaded');
                if (this.addressSelect) {
                    this.isMapInitialized = true;
                    console.log('MAP BEFORE INITIALIZATION SUCCESS');
                    this.initializeMap();
                    console.log('MAP AFTER INITIALIZATION SUCCESS');
                }

            })
            .catch(error => {
                console.error('Error loading ArcGIS API:', error);
            });
    }

    initializeMap() {
        
        require([
            'esri/config',
            'esri/core/urlUtils',
            'esri/Map',
            'esri/views/MapView',
            'esri/geometry/support/webMercatorUtils',
            'esri/tasks/Locator',
            'esri/Graphic',
            'esri/geometry/Point',
            'esri/layers/FeatureLayer',
            'esri/identity/IdentityManager',
            'esri/symbols/SimpleMarkerSymbol'
        ], (esriConfig, Utils, Map, MapView, webMercatorUtils, Locator, Graphic, Point, FeatureLayer, SimpleMarkerSymbol, IdentityManager) => {
            this.map = new Map({
                basemap: 'topo-vector'
            });

            this.view = new MapView({
                container: this.template.querySelector('.map'),
                map: this.map,
                center: [-118.71511, 34.09042],
                zoom: 18
            });

            this.locator = new Locator({
                url: 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer'
            });

        });


    }

    addMarker(address) {
        let conf = this.SF_Label;
        this.addressSelect = false;
        require([
            'esri/tasks/Locator',
            'esri/Graphic',
            'esri/geometry/Point',
            'esri/symbols/SimpleMarkerSymbol',
            'esri/PopupTemplate',
            'esri/identity/IdentityManager'
        ], (Locator, Graphic, Point, SimpleMarkerSymbol, PopupTemplate, IdentityManager) => {

            IdentityManager.registerToken({
                server: conf.urlPrefix,
                token: conf.gisToken,
            });

            const locator = new Locator({
                url: 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer'
            });

            // Geocode the address to get location
            locator.addressToLocations({
                address: {
                    "SingleLine": this.address
                }
            }).then((results) => {
                if (results.length) {
                    const location = results[0].location;
                    const point = new Point({
                        longitude: location.x,
                        latitude: location.y
                    });

                    const markerSymbol = new SimpleMarkerSymbol({
                        color: [255, 0, 0],
                        outline: {
                            color: [255, 255, 255],
                            width: 2
                        }
                    });

                    // Create a popup template for the marker
                    const popupTemplate = new PopupTemplate({

                        title: address,
                        content: "{address}"
                    });

                    // Create the point graphic (marker)
                    const pointGraphic = new Graphic({
                        geometry: point,
                        symbol: {
                            type: 'simple-marker',
                            color: 'red',
                            size: '14px'
                        },
                        popupTemplate: popupTemplate
                    });

                    // Add the marker to the map
                    this.view.graphics.add(pointGraphic);

                    // Center the view at the marker location
                    this.view.center = point;
                    this.view.on('click', (event) => {
                        const newLocation = event.mapPoint;
                        pointGraphic.geometry = newLocation; // Move the marker

                        // Reverse geocode to get the address of the new location
                        locator.locationToAddress({ location: newLocation })
                            .then((response) => {
                                const newAddress = response.address || "No address found";
                                const latitude = newLocation.latitude;
                                const longitude = newLocation.longitude;
                                this.coordinates.latitude = newLocation.latitude;
                                this.coordinates.longitude = newLocation.longitude;
                                this.propertyRecordDetails['PBS_AAAP_X_CO_ORD__c'] = newLocation.latitude;
                                this.propertyRecordDetails['PBS_AAAP_Y_CO_ORD__c'] = newLocation.longitude;
                                this.offerDetails['PBS_AAAP_X_CO_ORD__c'] = newLocation.latitude;
                                this.offerDetails['PBS_AAAP_Y_CO_ORD__c'] = newLocation.longitude;
                                this.county = response.attributes.Subregion;
                                this.propertyRecordDetails['PBS_AAAP_County__c'] = this.county;
                                this.offerDetails['PBS_AAAP_County__c'] = this.county;
                                this.newAddress = newAddress; // Store the new address
                                let modifiedAddress = newAddress.replace(/,?\s?Apt\s?\d{1,}/i, "");
                                this.address = modifiedAddress; // Update address
                                this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = modifiedAddress;
                                this.offerDetails['PBS_AAAP_Street_Address__c'] = modifiedAddress;
                                this.extractnewAddressDetails(modifiedAddress);
                                this.addrow();
                                // Update popup content with new address
                                pointGraphic.popupTemplate = new PopupTemplate({
                                    title: modifiedAddress,
                                    content: `<b>Latitude:</b> ${latitude}<br/>
                                          <b>Longitude:</b> ${longitude}`
                                });


                            })
                            .catch((error) => {
                                console.error('Error getting address:', error);
                                this.newAddress = 'No address found';
                            });
                    });
                }
            });
        });
    }
    handleSuggestionClick(event) {
        this.propertyAddress = event.currentTarget.dataset.address;
        this.addressSuggestions = [];
    }
    handleCountySelection(lat, lng) {
        let inputs = this.SF_Label;
        require([
            'esri/tasks/Locator',
            'esri/identity/IdentityManager'
        ], (Locator, IdentityManager) => {
            IdentityManager.registerToken({
                server: inputs.urlPrefix,
                token: inputs.gisToken,

            });
            const locator = new Locator({
                url: 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer'
            });

            locator.locationToAddress({
                location: { latitude: lat, longitude: lng }
            }).then((result) => {
                console.log('RESULT', result);
                if (result && result.address) {
                    this.county = result.attributes.Subregion;
                    this.propertyRecordDetails['PBS_AAAP_County__c'] = this.county;
                    this.offerDetails['PBS_AAAP_County__c'] = this.county;
                    this.addrow();

                    this.addMarker(result.address);

                    console.log('COUNTY IS', this.county);
                }

            });
        });



    }
    fetchCounty(lat, lng) {
        let inputs = this.SF_Label;
        require([
            'esri/tasks/Locator',
            'esri/identity/IdentityManager'
        ], (Locator, IdentityManager) => {
            IdentityManager.registerToken({
                server: inputs.urlPrefix,
                token: inputs.gisToken,

            });
            const locator = new Locator({
                url: 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer'
            });

            locator.locationToAddress({
                location: { latitude: lat, longitude: lng }
            }).then((result) => {
                console.log('RESULT', result);
                if (result && result.address) {
                    this.county = result.attributes.Subregion;
                    this.propertyRecordDetails['PBS_AAAP_County__c'] = this.county;
                    this.offerDetails['PBS_AAAP_County__c'] = this.county;
                    this.addrow();

                    this.addMarker(result.address);
                    this.showMap = true;
                    console.log('COUNTY IS', this.county);  // This will log the county name
                }
            });
        });

    }
    handleSelect(event) {

        console.log('Inside Handle Select');
        const selectedLabel = event.currentTarget.dataset.label;
        console.log('Label', selectedLabel);
        this.addressSelect = true;
        this.showSuggestions = false;

        this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = selectedLabel;
        this.propertyRecordDetails['PBS_AAAP_User_Defined_Address__c'] = selectedLabel;
        this.offerDetails['PBS_AAAP_Street_Address__c'] = selectedLabel;
        this.extractAddressDetails(selectedLabel);
        this.getCoordinates(selectedLabel);

        this.propertyAddress = selectedLabel;
        this.address = selectedLabel;
        this.showMap = true;

        this.template.querySelector('propertyAddress').value = this.address;
        console.log('Selected Address', this.address);

    }
    addrow() {
        this.addrdata = [];
        const newrow = { id: '1', street: this.street, city: this.city, state: this.state, zipCode: this.zipCode, county: this.county, latitude: this.coordinates.latitude, longitude: this.coordinates.longitude };
        this.addrdata = [...this.addrdata, newrow];
        if (this.saveActionName === 'SaveandNext') {
            this.isaddrdata = false;
        }
        else {
            this.isaddrdata = true;
        }
        console.log('DATATABLE', this.addrdata);
    }
    addlatlongrow() {
        this.addrdata = [];
        const newrow = { id: '1', street: this.street, city: this.city, state: this.state, zipCode: this.zipCode, county: this.county, latitude: this.latitude, longitude: this.longitude };
        this.addrdata = [...this.addrdata, newrow];


        this.isaddrdata = true;

        console.log('ADDLATLONGROWDATATABLE', this.addrdata);
    }
    handleHelpClick() {
        this.isHelpModalOpen = true;
    }
    handleModalClose() {
        this.isHelpModalOpen = false;
    }

    handleSubmit() {
        if (this.propertyAddress) {
            this.showMap = true;
            this.initializeMap();
        }
    }
    handleAutoSubmit(event) {
        event.preventDefault();
    }
    handleCancel() {
        this.showlatitude = false;

    }




    handleSave() {
        // Check if propertyId exists
        //validationPageName = 'Offer-Location';
        this.showbtn = true;
        this.propertyRecordDetails['PBS_AAAP_Building_Name__c'] = this.propertyName;
        this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.address;
        this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.street;
        this.offerDetails['PBS_AAAP_Building_Name__c'] = this.propertyName;
        this.offerDetails['PBS_AAAP_Street_Address__c'] = this.address;
        this.offerDetails['PBS_AAAP_Street_Address__c'] = this.street;
        if (this.propertyId) {

            this.extractAddressDetails(this.address);
            this.getlatlong(this.address);
            this.isaddrdata = true;
            this.updateProperty();
            if (this.offerId) {
                this.updateOffer();
            }
        }
        else if (this.offerId) {
            this.updateOffer();
        }
        else {
            // Create a new property
            if (!this.newPropId) {
                this.createProperty();
            }
        }
    }

    handleNext() {
        if(!this.editMode){

            if((!this.offerId) && (this.offerId === undefined))
                {
                window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&propertyId=' + this.propertyId;
                }
                else if(this.offerId &&(this.propertyId != '' && this.propertyId != undefined && this.propertyId != null)){
                    window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+this.propertyId;
                }
                else if(this.offerId)
                {
                    window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId;
                }
        }else {
            this.errors = [];
            if (this.propertyName == null || this.propertyName == undefined || this.propertyName == '' || this.address == null || this.address == undefined || this.address == '') {
                const scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
                if ((this.propertyName == null || this.propertyName == undefined || this.propertyName == '') && (this.address == null || this.address == undefined || this.address == '')) {
                    this.errors[0] = 'Location Page: 1. Property name is required.';
                    this.errors[1] = 'Location Page: 2. Property address is required.';
                }
                else if (this.propertyName == null || this.propertyName == undefined || this.propertyName == '') {
                    this.errors[0] = 'Location Page: 1. Property name is required.';
                    this.validationError = true;
                }
                else {
                    this.errors[0] = 'Location Page: 2. Property address is required.';
                }

            }

            else if (!this.isConfirm) {

                alert(
                    'Confirm selected address\n' +
                    'Click the Submit link next to the Property address field to show the map.  In order to proceed to the next page, click the Confirm Address button above the map next to the stated Latitude and Longitude figures if the map correctly shows the location of your property. ' +
                    '\n' +
                    this.address

                );
            }
            else {
                this.saveActionName = 'SaveandNext';
                this.showbtn = true;
                this.addressSelect = false;
                this.propertyRecordDetails['PBS_AAAP_Building_Name__c'] = this.propertyName;
                this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.address;
                this.extractAddressDetails(this.address);
                this.propertyRecordDetails['PBS_AAAP_Street_Address__c'] = this.street;
                this.offerDetails['PBS_AAAP_Building_Name__c'] = this.propertyName;
                this.offerDetails['PBS_AAAP_Street_Address__c'] = this.address;
                this.offerDetails['PBS_AAAP_Street_Address__c'] = this.street;
                this.isaddrdata = false;

                if (this.propertyId || this.newPropId) {
                    // Update the existing property
                    if (this.newPropId) {
                        this.propertyId = this.newPropId;
                        this.propertyRecordDetails['Id'] = this.newPropId;
                        this.isNewOffer = true;
                    }

                    if (this.offerId) {

                    }
                    this.updateProperty();
                    if (this.offerId) {

                        this.updateOffer();
                    }


                } else {
                   
                }
            }
        }
    }
    updateUrlWithPropertyId(propertyId) {
        // Get the current URL
        this.newPropId = propertyId;
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('propertyId', propertyId);
        window.history.pushState({}, '', currentUrl);

    }
    // Method to create a new property
    createProperty() {
        //validationPageName = 'Offer-Location'
        console.log('PROPERTYDETAILSBEFORECREATE' + JSON.stringify(this.propertyRecordDetails));
        createPropertyRecord({ propertyRecord: this.propertyRecordDetails, pageName: this.validationPageName })
            .then(result => {
                this.isSuccess = true;
                this.isError = false;
                this.showbtn = true;
                // Navigate to next page with the new Property Id in the URL
                if (this.saveActionName === 'Save') {
                    if (result.isSuccess === true) {

                        this.updateUrlWithPropertyId(result.propId);
                        //this.propertyId = result.propId;
                        this.showbtn = true;
                        if((!this.offerId) && (this.offerId === undefined))
                            {
                            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&propertyId=' + result.propId;
                            }
                            else if(this.offerId &&(result.propId != '' && result.propId != undefined && result.propId != null)){
                                window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+result.propId;
                            }
                            else if(this.offerId)
                            {
                                window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId;
                            }

                    }
                    else {
                        const scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        this.errors = result.errorMessages;
                    }

                } else {
                    if (result.isSuccess === true) {
                        this.showbtn = true;
                        if((!this.offerId) && (this.offerId === undefined))
                            {
                            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&propertyId=' + result.propId;
                            }
                            else if(this.offerId &&(result.propId != '' && result.propId != undefined && result.propId != null)){
                                window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+result.propId;
                            }
                            else if(this.offerId)
                            {
                                window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId;
                            }
                    }
                    else {
                        const scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        console.log('CREATEERRORMESSAGEIS' + result.errorMessages);
                        this.errors = result.errorMessages;
                    }
                }
            })
            .catch(error => {
                console.error('Error creating property record:', error);
                this.isError = true;
                this.isSuccess = false;
            });
    }

    updateOffer() {
        console.log('OFFERDETAILSBEFOREUPDATE', this.offerDetails);
        updateOfferRecord({ offerRecord: this.offerDetails, pageName: this.validationPageName })
            .then(result => {

                if (result.isSuccess === true) {

                    this.updateUrlWithPropertyId(result.propId);
                    //this.propertyId = result.propId;
                    this.showbtn = true;
                    if (this.saveActionName === 'SaveAndNavigate') {
                        window.location.href = this.navigateURL;
                    }else{
                        if((!this.offerId) && (this.offerId === undefined)){
                        window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&propertyId=' + result.propId;
                        }
                        else if(this.offerId &&(result.propId != '' && result.propId != undefined && result.propId != null)){
                            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId +'&propertyId='+result.propId;
                        }
                        else if(this.offerId){
                            window.location.href = '/leasing/s/Offer-Overview?edit='+this.editMode+'&offerId=' +this.offerId;
                        }
                    }
                }

            })
            .catch(error => {
                console.error('Error updating offer record:', error);
                this.isError = true;
                this.isSuccess = false;
            });
    }
    // Method to update the existing property
    updateProperty() {
        //validationPageName = 'Offer-Location'
        console.log('PROPERTYDETAILSBEFORUPDATE' + JSON.stringify(this.propertyRecordDetails));
        console.log('PROPERTYDATA', this.propertyData);

        saveProperty({ propertyRecord: this.propertyRecordDetails, pageName: this.validationPageName })
            .then(result => {
                this.isSuccess = true;
                this.isError = false;
                this.showbtn = true;
                // Navigate to the next page without creating a new record
                if (this.saveActionName === 'Save') {
                    if (result.isSuccess === true && !this.isConfirm) {
                        if ((!this.offerId) && (this.offerId === undefined)) {
                            window.location.href = '/leasing/s/Offer-Location?propertyId=' + this.propertyId + '&edit=' + this.editMode;
                        }
                        else if (this.offerId) {
                            window.location.href = '/leasing/s/Offer-Location?offerId=' + this.offerId + '&propertyId=' + this.propertyId + '&edit=' + this.editMode;
                        }
                    }
                    else if (result.isSuccess === true) {
       
                        if ((!this.offerId) && (this.offerId === undefined)) {
                            window.location.href = '/leasing/s/Offer-Overview?edit=' + this.editMode + '&propertyId=' + this.propertyId;
                        }
                        else if (this.offerId) {
                            window.location.href = '/leasing/s/Offer-Overview?edit=' + this.editMode + '&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
                        }
                    }
                    else if (result.isSuccess === false) {
                        const scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        this.errors = result.errorMessages;
                    }

                } else if (this.saveActionName === 'SaveAndNavigate') {
                    if (result.isSuccess === false) {
                        const scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        this.errors = result.errorMessages;
                    } else {
                        window.location.href = this.navigateURL;
                    }
                }
                else {
                    if (result.isSuccess === true) {
                        if ((!this.offerId) && (this.offerId === undefined)) {
                            window.location.href = '/leasing/s/Offer-Overview?edit=' + this.editMode + '&propertyId=' + this.propertyId;
                        }
                        else if (this.offerId) {
                            window.location.href = '/leasing/s/Offer-Overview?edit=' + this.editMode + '&offerId=' + this.offerId + '&propertyId=' + this.propertyId;
                        }
                    }
                    else {

                        const scrollOptions = {
                            left: 0,
                            top: 0,
                            behavior: 'smooth'
                        }
                        window.scrollTo(scrollOptions);
                        this.errors = result.errorMessages;
                    }
                }

            })
            .catch(error => {
                console.error('Error updating property record:', error);
                this.isError = true;
                this.isSuccess = false;
            });
    }
    handleExit() {
        if (confirm('Please make sure that, you have saved changes to the property, before leaving from this page.')) {
            window.parent.location.href = 'Offer-Home';
        }
    }
    handlePageUpdate() {
        console.log("I am near handle Page");
        this.showlatitude = true;

    }

    handleNavigateToPage(ev) {
        if (!this.editMode) {
            window.location.href = ev.detail.message;
        } else {
            this.errors = [];
            if (this.propertyName == null || this.propertyName == undefined || this.propertyName == '' || this.address == null || this.address == undefined || this.address == '') {
                const scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
                if ((this.propertyName == null || this.propertyName == undefined || this.propertyName == '') && (this.address == null || this.address == undefined || this.address == '')) {
                    this.errors[0] = 'Location Page: 1. Property name is required.';
                    this.errors[1] = 'Location Page: 2. Property address is required.';
                }
                else if (this.propertyName == null || this.propertyName == undefined || this.propertyName == '') {
                    this.errors[0] = 'Location Page: 1. Property name is required.';
                    this.validationError = true;
                }
                else {
                    this.errors[0] = 'Location Page: 2. Property address is required.';
                }

            }

            else if (!this.isConfirm) {

                alert(
                    'Confirm selected address\n' +
                    'Click the Submit link next to the Property address field to show the map.  In order to proceed to the next page, click the Confirm Address button above the map next to the stated Latitude and Longitude figures if the map correctly shows the location of your property. ' +
                    '\n' +
                    this.address

                );
            }
            else {

                this.saveProgressBar = true;
                this.saveActionName = 'SaveAndNavigate';
                this.navigateURL = ev.detail.message;
                console.log(this.navigateURL);
                this.handleSave();
            }
        }
    }
    handleStreetView(event) {
        this.map.basemap = 'topo-vector';
        this.setView('topo-vector');

    }
    handleSatelliteView(event) {
        this.map.basemap = 'hybrid';
        this.setView('hybrid');
    }

    handleFloodLayer(event) {
        console.log('Starting loadFloodZoneLayer() function...');
        let container = this.template.querySelector('.map');
        const floodLayer = this.layers.FloodZoneLayer;
        if (floodLayer) {
            this.map.layers.remove(floodLayer);
            console.log('SeismicLayerremoved');
            delete this.layers.FloodZoneLayer;

        }
        else {
            require([
                'esri/layers/MapImageLayer'
            ], (MapImageLayer) => {

                if (!this.layers) {
                    this.layers = {};
                }

                this.layers.FloodZoneLayer = new MapImageLayer({
                    url: 'https://hazards.fema.gov/arcgis/rest/services/public/NFHL/MapServer',
                    opacity: 0.3,
                    sublayers: [{
                        id: 28,
                        visible: true
                    }]
                });

                this.map.layers.add(this.layers.FloodZoneLayer);

                // Handle layer load
                this.view.whenLayerView(this.layers.FloodZoneLayer).then((layerView) => {
                    container.classList.remove('loading'); // Hide loading overlay
                });
            });

        }
    }
    handleSeismicLayer(event) {

        console.log('Starting loadSeismicLayer() function...');
        let container = this.template.querySelector('.map');
        const seismicLayer = this.layers.SeismicLayer;
        if (seismicLayer) {
            this.map.layers.remove(seismicLayer);
            console.log('SeismicLayerremoved');
            delete this.layers.SeismicLayer;

        }
        else {
            require([
                'esri/layers/FeatureLayer',
                'esri/PopupTemplate',
                'esri/rest/support/Query'
            ], (FeatureLayer, PopupTemplate, Query) => {

                if (!this.layers) {
                    this.layers = {};
                }

                let popupTemplate = new PopupTemplate({
                    title: 'Attributes',
                    content: '{*}'
                });

                this.layers.SeismicLayer = new FeatureLayer({
                    url: 'https://gis.gsa.gov/servernh/rest/services/GSA/GSASeismicRating/MapServer/0',
                    outFields: ['*'],
                    opacity: 0.3,
                    popupTemplate: popupTemplate
                });


                this.map.layers.add(this.layers.SeismicLayer);


                // Handle layer load
                this.view.whenLayerView(this.layers.SeismicLayer).then((layerView) => {
                    container.classList.remove('loading'); // Hide loading overlay
                });

                let query = new Query({
                    geometry: this.view.extent,
                    spatialRelationship: Query.SPATIAL_REL_INTERSECTS,
                    returnGeometry: true,
                    outFields: ['*']
                });

                this.layers.SeismicLayer.queryFeatures(query).then((featureSet) => {
                    console.log('Query result: ', featureSet);
                });

            });

        }
    }

    handleMap() {

        console.log('SHOWMAP1', this.showMap);
        console.log('SUBMITTED ADDRESS', this.address);
        if (this.address == null || this.address == '') {
            alert('Please enter a street address and try again.  If complications persist, please email leasing@gsa.gov or call 1-866-450-6588 and select option 7. ');
        }
        else {
            if (!this.addressSelect && !this.propertyId && !this.offerId) {
                this.address = this.firstSuggestion;
            }
            this.showSuggestions = false;
            this.isaddrdata = true;
            this.initializeMap();
            this.extractnewAddressDetails(this.address);
            this.getlatlong(this.address);
            this.showMap = true;
        }
    }
    handleShowMap() {

        if (this.latitude && this.longitude)
        {
            this.extractnewAddressDetails(this.address);
            this.showLocation();
            this.showmapHide = false;
        }
        else{
        console.log('SHOWMAP1', this.showMap);
        console.log('SUBMITTED ADDRESS', this.address);
        if (!this.addressSelect && !this.propertyId && !this.offerId) {
            this.address = this.firstSuggestion;
        }
        this.showSuggestions = false;
        this.isaddrdata = true;
        this.showmapHide = false;
        this.initializeMap();
        this.extractnewAddressDetails(this.address);
        this.getlatlong(this.address);
        this.showMap = true;
       }
    }

    handleLatChange(event) {
        this.latitude = event.target.value;
        this.propertyRecordDetails[event.target.fieldName] = event.target.value;
        this.offerDetails[event.target.fieldName] = event.target.value; 
    }

    handleLongChange(event) {
        this.longitude = event.target.value;
        this.propertyRecordDetails[event.target.fieldName] = event.target.value;
        this.offerDetails[event.target.fieldName] = event.target.value; 
    }
    showLocation() {
        if (this.latitude && this.longitude) {

            console.log('Lat result: ', this.latitude);
            console.log('Long result: ', this.longitude);

            this.showMap = true;

            this.loadMap(this.latitude, this.longitude);
        } else {
            alert('Please enter valid latitude and longitude.');
        }
    }

    loadMap(latitude, longitude) {
        let inputparams = this.SF_Label;

        require([
            'esri/tasks/Locator',
            'esri/Map',
            'esri/views/MapView',
            'esri/Graphic',
            'esri/geometry/Point',
            'esri/identity/IdentityManager'
        ], (Locator, Map, MapView, Graphic, Point, IdentityManager) => {

            IdentityManager.registerToken({
                server: inputparams.urlPrefix,
                token: inputparams.gisToken,

            });

            const locator = new Locator({
                url: 'https://gis.gsa.gov/servernh/rest/services/GSA/USA/GeocodeServer'
            });
            this.map = new Map({
                basemap: 'topo-vector'
            });

            this.view = new MapView({
                container: this.template.querySelector('.map'),
                map: this.map,
                center: [longitude, latitude],
                zoom: 18
            });

            // Add a point marker at the specified latitude and longitude
            const point = new Point({
                longitude: longitude,
                latitude: latitude
            });

            const graphic = new Graphic({
                geometry: point,
                symbol: {
                    type: 'simple-marker',
                    color: 'red',
                    size: '14px'
                }
            });

            this.view.graphics.add(graphic);
        });
        this.latitude = latitude;
        this.longitude = longitude;
        this.addlatlongrow()
    }
    confirmAddr(event) {
        const addrId = event.target.dataset.id;
        this.showmapHide = true;

        console.log('ADDRID', this.addrId);

        this.showMap = false;
        this.showbtn = true;
        this.addressSelect = false;
        const result = confirm(
            'Confirm Selected Address\n' +
            'Are you sure you wish to confirm the following ' +
            ' address?\n' +
            this.address

        );
        console.log('RESULTCONFIRM ', result);
        this.showMap = true;
        if (result) {
            this.isConfirm = true;
            this.saveActionName = 'Save';
            console.log('RESULTCONFIRMINSIDEIF ', result);
            this.handleSave();
        }
    }
    openHandleModal(event) {
        console.log('openHandleModal ', event.target.dataset.infotype);
        if (event.target.dataset.infotype == 'Property Address') {
            this.infoDetials = `Tips for establishing your building address and location:<br/><br/><tr><td>1.</td><td>  Begin entering your building address and click on the provided autocomplete option that matches your building’s address. If none are presented that match your location, finish typing the full address then click the Submit link next to the field.<br><br></td></tr><tr><td>2.</td><td>  If the map plots a location that is not correct, but the full address is stated correctly in the #3 Building Address field, click on the link to manually enter the latitude and longitude then click the Submit link after entering the correct information. (Example: Latitude 30.123456, Longitude -70.123456)<br><br></td></tr><tr><td>3.</td><td>  If the above solutions do not result in an accurate location, you can manually navigate the map on the page and double click on your building within the map to place a marker on the location of your building. Note that the address that populates may not be precise or formatted correctly, but this can be remedied at a later date. It is more important to have an accurate location established up front.<br><br></td></tr><tr><td>4.</td><td>  Use the street address of the building you are proposing to lease. Do not use the mailing address of a different location, a street corner, the building name, or some other description such as a post office box number.</td></tr>`;
        }
        this.isShowModal = true;
    }
    mapWrapperFields(data) {
        return {
            Id: data.Id,
            PBS_AAAP_Building_Name__c: data.PBS_AAAP_Building_Name,
            PBS_AAAP_Street_Address__c: data.PBS_AAAP_Street_Address,
            PBS_AAAP_User_Defined_Address__c: data.PBS_AAAP_User_Defined_Address,
            PBS_AAAP_City__c: data.PBS_AAAP_City,
            PBS_AAAP_State__c: data.PBS_AAAP_State,
            PBS_AAAP_County__c: data.PBS_AAAP_County,
            PBS_AAAP_X_CO_ORD__c: data.PBS_AAAP_X_CO_ORD,
            PBS_AAAP_Y_CO_ORD__c: data.PBS_AAAP_Y_CO_ORD,
            PBS_AAAP_ZipCode__c: data.PBS_AAAP_ZipCode,
            PBS_AAAP_floors_Suites_in_Offered_Space__c: data.PBS_AAAP_floors_Suites_in_Offered_Space,
            PBS_AAAP_Number_of_floors__c: data.PBS_AAAP_floors_Suites_in_Offered_Space,
            PBS_AAAP_OFFICE_SPACE_RSF__c: data.PBS_AAAP_OFFICE_SPACE_RSF,
            PBS_AAAP_RETAIL_SPACE_RSF__c: data.PBS_AAAP_RETAIL_SPACE_RSF,
            PBS_AAAP_GARAGE_SPACE_RSF__c: data.PBS_AAAP_GARAGE_SPACE_RSF,
            PBS_AAAP_GEN_PURPOSE_RENTABLE__c: data.PBS_AAAP_GEN_PURPOSE_RENTABLE,
            PBS_AAAP_TOTAL_BOMA_USF_OFFERED__c: data.PBS_AAAP_TOTAL_BOMA_USF_OFFERED,
            PBS_AAAP_Common_Area_Factor__c: data.PBS_AAAP_Common_Area_Factor,
            PBS_AAAP_Total_Surface_Parking_Spaces__c: data.PBS_AAAP_Total_Surface_Parking_Spaces,
            PBS_AAAP_Total_Structured_Parking_Spaces__c: data.PBS_AAAP_Total_Structured_Parking_Spaces,
            PBS_AAAP_Total_Park_Spaces_Offered__c: data.PBS_AAAP_Total_Park_Spaces_Offered,
            PBS_AAAP_Year_Built__c: data.PBS_AAAP_Year_Built,
            PBS_AAAP_Renovation_Year__c: data.PBS_AAAP_Renovation_Year,
            PBS_AAAP_HVAC_HRS_MON_TO_FRI_START__c: data.PBS_AAAP_HVAC_HRS_MON_TO_FRI_START,
            PBS_AAAP_HVAC_HRS_MON_TO_FRI_END__c: data.PBS_AAAP_HVAC_HRS_MON_TO_FRI_END,
            PBS_AAAP_HVAC_HRS_ON_SAT_START__c: data.PBS_AAAP_HVAC_HRS_ON_SAT_START,
            PBS_AAAP_HVAC_HRS_ON_SAT_END__c: data.PBS_AAAP_HVAC_HRS_ON_SAT_END,
            PBS_AAAP_HVAC_HRS_ON_SUN_START__c: data.PBS_AAAP_HVAC_HRS_ON_SUN_START,
            PBS_AAAP_HVAC_HRS_ON_SUN_END__c: data.PBS_AAAP_HVAC_HRS_ON_SUN_END,
            PBS_AAAP_Owner_Name__c: data.PBS_AAAP_Owner_Name,
            PBS_RSAP_Property_Owner_Same_as_Offeror__c: data.PBS_RSAP_Property_Owner_Same_as_Offeror,
            PBS_AAAP_Owner_Address__c: data.PBS_AAAP_Owner_Address,
            PBS_AAAP_Owner_City__c: data.PBS_AAAP_Owner_City,
            PBS_AAAP_Owner_State__c: data.PBS_AAAP_Owner_State,
            PBS_AAAP_Owner_Zip__c: data.PBS_AAAP_Owner_Zip,
            PBS_AAAP_Parking_Onsite__c: data.PBS_AAAP_Parking_Onsite,
            PBS_AAAP_OFFEROR_INTEREST__c: data.PBS_AAAP_OFFEROR_INTEREST,
            PBS_AAAP_DUNS_Number__c: data.PBS_AAAP_DUNS_Number
        };
    }
    get isDisabled() {
        return !this.editMode;
    }

}