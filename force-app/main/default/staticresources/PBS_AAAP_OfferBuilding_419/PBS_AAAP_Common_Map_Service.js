/*ArcGIS JS API v4.19 Common Map Service Class. Contains the ESRI callout along with the layers, which is currently commented out*/
/*refactored June 2021 by Julia Kantarovsky*/

//console.log('Common Map Service load');

//Object declaration and constructor
function ArcGIS_v4_19(config) {
    this.config = config;
    this.map = undefined;
    this.multipoint = undefined;
    this.mapview = undefined;
    this.points = {
        loading: 0
    };
    this.markers = {};
    this.layers = {};
};


/* Initialize the map.*/
//Init Method
ArcGIS_v4_19.prototype.init = function () {
    let self = this;
    return new Promise(function (resolve, reject) {
        require([
            'esri/config',
            'esri/core/urlUtils',
            'esri/Map',
            'esri/views/MapView',
            'esri/geometry/support/webMercatorUtils',
            'esri/tasks/Locator',
            'esri/geometry/Extent',
            'esri/geometry/Multipoint',
            'esri/Graphic',
            'esri/layers/GraphicsLayer',
            'esri/geometry/Point',
            'esri/PopupTemplate'
        ], function (esriConfig, Utils, Map, MapView, webMercatorUtils, Locator, Extent, Multipoint, Graphic, GraphicsLayer, Point, PopupTemplate) {
            //setting global variables from module imports for use in Utility and Interface files (bind to this)
            self.esriConfig = esriConfig;
            self.webMercatorUtils = webMercatorUtils;
            self.popupTemplate = PopupTemplate;
            /*self.locator = new Locator({
                url: self.config.locatorUrl
            })*/
            Utils.addProxyRule({
                urlPrefix: SF_Label.urlPrefix,  // 'https://extgsagis.gsa.gov',
                proxyUrl: SF_Label.proxyUrl     // 'https://aaapextsb.pbs.gsa.gov/proxy/proxy.ashx'
            });

            // Create new map and view instance.
            self.map = new Map({
                basemap: 'topo-vector',
            });

            self.mapview = new MapView({
                map: self.map,
                container: self.config.container,
                zoom: 4,
                center: [39.8283, 98.5795],
                extent: {//from documentation. extent takes precendence over zoom and center. Setting the extent immediately changes the view without animation
                    xmin: -14177690,
                    ymin: 2618510,
                    xmax: -7084330,
                    ymax: 6532090,
                    spatialReference: {
                        wkid: 102100
                    }
                }
            })
            self.multipoint = new Multipoint({//was self, added instead of below in onload evt
                //spatialReference: self.mapview.extent.spatialReference
            })
            //instance of GraphicsLayer:
            self.graphicsLayer = new GraphicsLayer();
            //from the docs: //Each graphic in the GraphicsLayer is rendered in a LayerView inside either a SceneView or a MapView. 
            self.mapview.map.add(self.graphicsLayer);

            //instance of a point, for use if map needs to be rendered on page load
            self.point = new Point({
                type: "point",
                longitude: self.config.newPoint.longitude,
                latitude: self.config.newPoint.latitude
            })

            //marker styling 
            self.simpleMarkerSymbol = {
                type: "simple-marker",  // autocasts as new SimpleMarkerSymbol()
                style: "circle",
                color: [255, 0, 0, 255],//red
                size: 10,  // pixels
                outline: {  // autocasts as new SimpleLineSymbol()
                    color: [0, 0, 0, 255],//this is where the color is getting set for the marker
                    width: 1
                }
            }

            //add graphic to graphics layer
            self.pointGraphic = new Graphic({
                geometry: self.point,
                symbol: self.simpleMarkerSymbol,
                attributes: undefined,
                popupTemplate: undefined
            });

            //functionality for when a user double clicks on the map
            self.mapview.on("double-click", function (event) {
                // The event object contains the mapPoint and the screen coordinates of the location that was clicked.
                /*var lat = Math.round(event.mapPoint.latitude * 1000) / 1000;
                var lon = Math.round(event.mapPoint.longitude * 1000) / 1000;
                var pt = new Point({
                    longitude: event.mapPoint.longitude,
                    latitude: event.mapPoint.latitude,
                });*/

                let doubleClick = true;//this is used as a param passed into the marker methods to determine if the marker was created from a doubleclick event

                // Execute a reverse geocode using the clicked location
                new Locator(
                    //'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GeoLocate/GeocodeServer'
                    //'https://extgsagis.gsa.gov/extgsagis/rest/services/GSA/GSA_USA/GeocodeServer'
                    //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
                    self.config.locatorUrl
                ).locationToAddress({ location: event.mapPoint })
                    .then(function (response) {
                        // When resolved successfully, the result is an AddressCandidate.
                        // Now that we have the address, we can create a marker and display it.
                        self
                            .addMarker(response.attributes.Match_addr, doubleClick, event)
                            .then(function (marker) {
                                // Callback for the map click event. When creating an instance of this class, you will create a click method on the config object which provides the newly created marker.
                                if (self.config.click) {
                                    self.config.click(marker);//this is the click method defined in the ArcGIS_Interface_OfferBuilding js file
                                }
                            })
                            .catch(function (err) {
                                //console.error(err);
                            });
                    });
            });

            // Load all the layers: This has been removed June 2021
            // Resolve the promise.
            resolve(self);//was self
        }, function (error) {
            // Use the errback function to handle when the view doesn't load properly
            console.log("The view's resources failed to load: ", error);
            reject(evt);
        });
    })
}