/*ArcGIS JS API v4.19 Utility Class. Includes method definitions*/

console.log('ArcGIS v4.19 Utility JS file loading...');

//getLocatorUrlByState method
ArcGIS_v4_19.prototype.getLocatorUrlByState = function (state) {

console.log('ArcGIS v4.19 Utility JS file, getLocatorUrlByState() starting...  state: ', state);

    switch (
    state
        .toString()
        .toUpperCase()
        .trim()
    ) {
        case 'PR':
            return SF_Label.locator.PR;
        case 'VI':
            return SF_Label.locator.VI;
        case 'GU':
            return SF_Label.locator.GU;
        default:
            return SF_Label.locator.USA;
    }
};

//moveMarker method
ArcGIS_v4_19.prototype.moveMarker = function (address, location) {

console.log('ArcGIS v4.19 Utility JS file moveMarker() starting...   address: ', address);
    
    let doubleClick = false;
    return new Promise(function (resolve, reject) {
        let coordinates = {
            longitude: location.lon,
            latitude: location.lat
        };

        let marker = this.createMarker(coordinates, address, doubleClick, dummyMethod);
        
console.log('MoveMarker function, marker returned from createMarker()', marker);

        //I added this as the callback, is not being called
        function dummyMethod(marker) {
            let marker2 = marker;
        }
        //
        // Add a new point to the mapview.
        this.mapview.graphics.add(marker);

        this.setExtent();

        //set unique marker ID
        let markerID = 'm' + (Math.random() * 1e32).toString(36);

        this.markers[markerID] = marker;

        resolve({
            id: markerID,
            address: address,
            location: {
                street: location.street,
                city: location.city,
                state: location.state,
                zip: location.zip,
                county: location.county,
                lat: location.lat,
                lon: location.lon
            }
        });
    }.bind(this));
};

// addMarker method, Add a single marker to the map.
ArcGIS_v4_19.prototype.addMarker = function (address, doubleClick, evt) {

console.log('ArcGIS v4.19 Utility JS file addMarker() starting...   address: ', address);

    return new Promise(
        function (resolve, reject) {
            this.points.loading++;
            this.addressToCoordinates(address)
                .then(
                    function (locations) {
                        //here coordinates are set for use in createMarker() param
                        let coordinates = {
                            longitude: locations[0].attributes.DisplayX,
                            latitude: locations[0].attributes.DisplayY
                        };
                        let location = locations[0].attributes;

                        if (evt) {
                            //never reaches this, no evt is never passed in as params to this function
                            coordinates = this.cartesianToGeolocation(
                                evt.mapPoint.x,
                                evt.mapPoint.y
                            );
                        }

                        this.points.loading--;
                        let marker2;
                        let marker = this.createMarker(coordinates, address, doubleClick, printMarker);
                        //console.log('addMarker, marker(graphic) returned from createMarker() ', marker);
                        function printMarker(marker) {//This callback method was added because graphics.add marker below doesn't know what marker is yet
                            marker2 = marker;
                        }
                        //remove any markers(instances of graphic) currently on the map:
                        this.mapview.graphics = [];
                        //add the new marker(instance of graphic) to the map
                        this.mapview.graphics.add(marker2);
                        if (this.points.loading === 0) {
                            // Reset the map extent.
                            this.setExtent();
                        }

                        let markerID = 'm' + (Math.random() * 1e32).toString(36);

                        this.markers[markerID] = marker2;//this was previously used as a param in remove markers methods, but now we are removing markers in the current method(above code). Leaving this here in case we need it at a later date.

                        resolve({
                            id: markerID,
                            address: address,
                            location: {
                                street: location.StAddr,
                                city: location.City,
                                state: location.RegionAbbr,
                                zip: location.Postal,
                                county: location.Subregion,
                                lat: coordinates.latitude,
                                lon: coordinates.longitude,
                                geometry: marker2.geometry
                            }
                        });
                    }.bind(this)
                )
                .catch(function (err) {
                    reject(err);
                });
        }.bind(this)
    );
};

//removeMarker method, Remove a single marker from the map.
//this method is not being called, all code has been commented out. remove marker functionality happens in the addMarker method
ArcGIS_v4_19.prototype.removeMarker = function (markerID) {
    /*let marker = this.markers[markerID];
    //NEED TO REMOVE GRAPHIC OBJECT FROM COLLECTION OF GRAPHICS,marker needs to be an instance of a Graphic object to get removed
    let graphic;
    require(["esri/Graphic"], function (Graphic) {
        graphic = new Graphic(marker);
    });

    let index = this.mapview.graphics.indexOf(graphic);
    if (index > -1) {
      this.mapview.graphics.splice(index, 1);
    }
    this.mapview.graphics.remove(marker);
    //removePoint: Removes a point from the Multipoint. The index specifies which point to remove.
    this.multipoint.removePoint(marker.geometry);
*/

};

//createMarker method, Create a single map marker. This simply creates the marker.  It still needs added to both the map and the multipoint set of points.
ArcGIS_v4_19.prototype.createMarker = function (coordinates, address, doubleClick, callback) {
    this.point.x = coordinates.longitude;
    this.point.y = coordinates.latitude;

    // Add the point to the point set.
    this.multipoint.addPoint(this.point);
    let attributes = {
        address: address
    }

    //user doubleClicked on the map
    if (doubleClick) {
        this.popupTemplate = {//// autocasts as new PopupTemplate()
            title: address,
            content: function () {
                var div = document.createElement("div");
                div.innerHTML = '<div><b>Latitude:</b> ' +
                    coordinates.latitude +
                    '</div>' +
                    '<div><b>Longitude:</b> ' +
                    coordinates.longitude +
                    '</div>';
                return div;
            },
        }
    } else {
        //user got to here by entering an address and clicking submit, or by clicking on a suggestion from the dropdown, or by clicking on the 'show map' button, or by entering lat lon
        this.popupTemplate = {
            title: address
        }
    }

    //Graphic needs properties: Create a new graphic and add the geometry,symbol, and attributes to it. You may also add a simple PopupTemplate to the graphic.This allows users to view the graphic'sattributes when it is clicked.
    this.pointGraphic = {
        geometry: this.point,
        symbol: this.pointGraphic.symbol,
        attributes: attributes,
        popupTemplate: this.popupTemplate
    }
    callback(this.pointGraphic);

    return this.pointGraphic;
}

//suggest method
ArcGIS_v4_19.prototype.suggest = function (location) {

console.log('ArcGIS v4.19 Utility JS file suggest() starting...   location: ', location);

    let map = this.map;
    let config = this.config;
    let locator = this.locator;

console.log('config: ', config);
//console.log('locator: ', locator);

if (location.singleLineAddress && location.singleLineAddress.length > 0) {
    let params = {
        text: location.singleLineAddress,
        categories: ["Subaddress", "Point Address", "Street Address"],
        minCharacters: 4,
        maxSuggestions: 10
    };

    console.log('About to perform Promise() for address lookup minChars 4 and maxSuggests 10 for address length: ', location.singleLineAddress.length);
    console.log('params: ' + JSON.stringify(params));

    return new Promise(function(resolve, reject) {

        require(['esri/tasks/Locator'], function(Locator) {
           
            new Locator(
                    config.locatorUrl
                )
                .suggestLocations(params)
                .then(function(suggestions) {
                    resolve(suggestions);
                })
                .catch(function(err) {
                    reject(err);
                });

        });
    });
    //Unreachable code: we should remove the following code block because the location param in the suggest method only contains the singleAddress property, not lat and lon. Therefore it will never go into this code block:
} else {
    if (
        location.lat &&
        location.lat.length > 0 &&
        location.lon &&
        location.lon.length > 0
    ) {
        return new Promise(function(resolve, reject) {
            require([
                'esri/geometry/Point',
                'esri/tasks/Locator'
            ], function(Point, Locator) {
                let point = new Point(
                    parseFloat(location.lat),
                    parseFloat(location.lon)
                );

                new Locator(
                        //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
                        config.locatorUrl
                    )
                    .locationToAddress(point)
                    .then(function(response) {
                        resolve([{
                            address: response.address.LongLabel,
                            parts: {
                                street: response.address.StAddr,
                                city: response.address.City,
                                state: response.address.Region,
                                zip: response.address.Postal
                            }
                        }]);
                    })
                    .catch(function(err) {
                        reject(err);
                    });
            });
        });
    }
}
};

//search method
ArcGIS_v4_19.prototype.search = function (location) {
    
console.log('ArcGIS v4.19 Utility JS file search() starting...    location: ', JSON.stringify(location));

    let doubleClick = false;
    if (location.singleLineAddress && location.singleLineAddress.length > 0) {
        return new Promise(
            function (resolve, reject) {
                this.addMarker(location.singleLineAddress, doubleClick)
                    .then(function (marker) {
                        //this marker is what gets used in the table
                        resolve(marker);
                    })
                    .catch(function (error) {
                        reject(error);
                    });
            }.bind(this)
        );
        //Unreachable code: we should remove the following code block because location property is only singleLineAddress, no lat or lon. Therefore, unreachable code block.
    } else if (
        location.lat &&
        location.lat.length > 0 &&
        location.lon &&
        location.lon.length > 0
    ) {
        return new Promise(
            function (resolve, reject) {
                this.coordinatesToAddress(location.lon, location.lat)
                    .then(
                        function (res) {
                            this.addMarker(res.address.LongLabel, doubleClick)
                                .then(function (marker) {
                                    resolve(marker);
                                })
                                .catch(function (error) {
                                    reject(error);
                                });
                        }.bind(this)
                    )
                    .catch(function (error) {
                        reject(error);
                    });
            }.bind(this)
        );
    } else {
        return new Promise(function (resolve, reject) {
            reject(false);
        });
    }
};

//coordinatesToAddress method, Converts a longitude / latitude pair to an address. This method is never called - see above, unreachable code
ArcGIS_v4_19.prototype.coordinatesToAddress = function (lon, lat) {
    let config = this.config;
    let point = this.point;

    return new Promise(function (resolve, reject) {
        require(['esri/tasks/Locator'], function (Locator) {
            new Locator(
                //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
                config.locatorUrl
            )
                .locationToAddress(
                    point.longitude = lon,
                    point.latitude = lat
                )
                .then(function (res) {
                    resolve(res);
                })
                .catch(function (err) {
                    reject(err);
                });
        });
    });
};

//addressToCoordinates method, Converts an address to a set of geocodes (longitude, latitude).
ArcGIS_v4_19.prototype.addressToCoordinates = function (address) {
    let config = this.config;
    return new Promise(function (resolve, reject) {
        require(['esri/tasks/Locator'], function (Locator) {
            new Locator(
                //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
                config.locatorUrl
            ).addressToLocations({
                address: {
                    SingleLine: address
                },
                outFields: ['*']
            })
                .then(function (res) {
                    resolve(res);
                })
                .catch(function (err) {
                    reject(err);
                });
        });
    });
};


//setExtent method. Setting the extent means that we are centering the map around a set of points and then zooming in as close as possible with all points showing on the map.
ArcGIS_v4_19.prototype.setExtent = function () {
    let points = this.multipoint.points;
    if (points.length === 0) {
        this.mapview.extent = {
            xmin: -14177690,
            ymin: 2618510,
            xmax: -7084330,
            ymax: 6532090,
            spatialReference: {
                wkid: 102100
            }
        };
    }

    // There is only one address.
    else if (points.length === 1) {
        this.mapview.goTo({
            center: points[0],
            zoom: 18
        })
            .catch(function (error) {
                if (error.name != "AbortError") {
                    console.error(error);
                }
            });
    }


    // There are multiple addresses.
    else if (points.length > 1) {
        this.mapview.goTo({
            center: points[points.length - 1],
            zoom: 18
        })
            .catch(function (error) {
                if (error.name != "AbortError") {
                    console.error(error);
                }
            });
    }
};

//cartesianToGeolocation method
ArcGIS_v4_19.prototype.cartesianToGeolocation = function (x, y) {
    //console.log('cartesianToGeolocation start');
    let coordinates = this.webMercatorUtils.xyToLngLat(x, y);
    return { longitude: coordinates[0], latitude: coordinates[1] };
};

//geolocationToCartesian method, Converts latitude and longitude into x and y cartesian coordinates.
ArcGIS_v4_19.prototype.geolocationToCartesian = function (lon, lat) {
    //console.log('geolocationToCartesian start');
    let cartesian = this.webMercatorUtils.lngLatToXY(lon, lat);
    return { x: cartesian[0], y: cartesian[1] };
};

ArcGIS_v4_19.prototype.setView = function (view) {
    console.log('ArcGIS_v419_Utility setView function');
    //this.map.setBasemap(view);
    this.map.basemap = view;
};

//loadAllLayers method. Load all the map layers.  
//This creates the layers.  It doesn't add them to the map. 
//JK This.addlayer was commented out in June 2021
ArcGIS_v4_19.prototype.loadAllLayers = function () {
    /*console.log('Layers', [
        'FloodZoneLayer',
        'SeismicLayer',
        'TransportationLayer',
        'CongressionalDistrictLayer'
    ]);*/
    //this.addLayer('CongressionalDistrictLayer');
    this.addLayer('FloodZoneLayer');
    this.addLayer('SeismicLayer');
};

//addLayer method. Add the requested layer.
ArcGIS_v4_19.prototype.addLayer = function (layer) {
    //console.log('add layer', layer);
    switch (layer) {
        case 'FloodZoneLayer':
            this.loadFloodZoneLayer();
            break;
        case 'SeismicLayer':
            this.loadSeismicLayer();
            break;
        case 'TransportationLayer':
            this.loadTransportationLayer();
            break;
        case 'CongressionalDistrictLayer':
            this.loadCongressionalDistrictLayer();
            break;
        case 'CentralBusinessDistrictLayer':
            this.loadCentralBusinessDistrictLayer();
            break;
    }
};

//removeLayer method. remove the selected layer
ArcGIS_v4_19.prototype.removeLayer = function (layer) {
    if (this.layers[layer]) {
	/* Todd Brown replaced the following version 3.29 "remove layer" logic with version 4.19 logic
        this.map.removeLayer(this.layers[layer]); */
        this.map.layers.remove(this.layers[layer]);
        delete this.layers[layer];
    }
};

ArcGIS_v4_19.prototype.loadCongressionalDistrictLayer = function () {
    //console.log('loadCongressionalDistrictLayer function');
    require(['esri/layers/FeatureLayer', 'esri/tasks/support/Query'], function (
        FeatureLayer,
        Query
    ) {
        this.layers.CongressionalDistrictLayer = new FeatureLayer(
            'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/boundaries/MapServer/1',
            {
                mode: FeatureLayer.MODE_ONDEMAND,
                outFields: ['*'],
                opacity: 0.3
            }
        );

        this.layers.CongressionalDistrictLayer.on(
            'update-end',
            function (event) {
                let query = new Query();
                query.geometry = this.map.extent;
                query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
                query.returnGeometry = true;
                query.outFields = ['*'];

                this.layers.CongressionalDistrictLayer.queryFeatures(
                    query,
                    function (featureSet) {
                        this.congressionalDistricts = featureSet.features;
                        //console.log('congressional districts', this.congressionalDistricts);
                        for (let i = 0; i < featureSet.features.length; i++) {
                            let feature = featureSet.features[i];
                            feature.geometry.clearCache();
                            break;
                        }
                    }.bind(this)
                );
            }.bind(this)
        );
        this.addLayer(this.layers.CongressionalDistrictLayer);
    }.bind(this));
};

ArcGIS_v4_19.prototype.loadSeismicLayer = function () {
    console.log('Starting loadSeismicLayer() function...');    
    let container = $('[id$="map_canvas"]');

    /* Todd Brown replaced Seismic Layer callouts 02/2023
    require([
        'esri/layers/FeatureLayer',
        'esri/PopupTemplate',
        'esri/tasks/query'
    ], function (FeatureLayer, PopupTemplate, Query) {
        let popupTemplate = new PopupTemplate('Attributes', '${*}');//this is the template object

        this.layers.SeismicLayer = new FeatureLayer(
            'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GSA_Seismic_Layer/MapServer/0',
            {
                mode: FeatureLayer.MODE_ONDEMAND,
                popupTemplate: popupTemplate,
                outFields: ['*'],
                opacity: 0.3
            }
        );

        this.map.addLayer(this.layers.SeismicLayer);

        this.layers.SeismicLayer.on('update-start', function (event) {
            container.LoadingOverlay('show', {
                imagePosition: 'center center',
                maxSize: '75px'
            });
        });

        this.layers.SeismicLayer.on('update-end', function () {
            container.LoadingOverlay('hide');
        });

        let query = new Query();
        query.geometry = this.map.extent;
        query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
        query.returnGeometry = true;
        query.outFields = ['*'];

        this.layers.SeismicLayer.queryFeatures(query, function (featureSet) {
            for (let i = 0; i < featureSet.features.length; i) {
                let feature = featureSet.features[i];
                feature.geometry.clearCache();
                break;
            }
        }); */

    container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
    });

    require([
        'esri/layers/FeatureLayer',
        'esri/PopupTemplate',
        'esri/rest/support/Query'
    ], function (FeatureLayer, PopupTemplate, Query) {

        if (!this.layers) {
            this.layers = {};
        }

        let popupTemplate = new PopupTemplate('Attributes', '${*}');//this is the template object

        this.layers.SeismicLayer = new FeatureLayer(
	    'https://gis.gsa.gov/servernh/rest/services/GSA/GSASeismicRating/MapServer/0',
            {
                mode: FeatureLayer.MODE_ONDEMAND,
                popupTemplate: popupTemplate,
                outFields: ['*'],
                opacity: 0.3
            }
        );

        this.map.allLayers.on('change', (event) => {
            if (event.added.length > 0) {
                event.added.forEach((layer) => {
                  console.log('layer(s) currently loaded: ' + layer.title);
                  container.LoadingOverlay('hide');
                });
            }
        });

        this.map.layers.add(this.layers.SeismicLayer);

        let query = new Query();
        query.geometry = this.map.extent;
        query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
        query.returnGeometry = true;
        query.outFields = ['*'];

        this.layers.SeismicLayer.queryFeatures(query, function (featureSet) {
            for (let i = 0; i < featureSet.features.length; i) {
                let feature = featureSet.features[i];
                feature.geometry.clearCache();
                break;
            }
        });

    }.bind(this));
};

ArcGIS_v4_19.prototype.loadFloodZoneLayer = function () {
    console.log('Starting loadFloodZoneLayer() function...');    
    let container = $('[id$="map_canvas"]');

    /* Todd Brown replaced flood zone layer callouts 02/2023
    require([
        'esri/layers/MapImageLayer',//'esri/layers/ArcGISDynamicMapServiceLayer',
        'esri/layers/support/ImageParameters'
    ], function (MapImageLayer, ImageParameters) {
        let imageParameters = new ImageParameters();
        imageParameters.format = 'PNG32'; //set the image type to PNG24, note default is PNG8.
        imageParameters.layerIds = [28];
        imageParameters.layerOption = ImageParameters.LAYER_OPTION_SHOW;

        this.layers.FloodZoneLayer = new MapImageLayer(
            'https://hazards.fema.gov/gis/nfhl/rest/services/public/NFHL/MapServer',
            {
                opacity: 0.3,
                imageParameters: imageParameters
            }
        );

        this.layers.FloodZoneLayer.on('update-start', function (event) {
            container.LoadingOverlay('show', {
                imagePosition: 'center center',
                maxSize: '75px'
            });
        });

        this.layers.FloodZoneLayer.on('update-end', function () {
            container.LoadingOverlay('hide');
        });

        this.map.addLayer(this.layers.FloodZoneLayer); 
	*/

      container.LoadingOverlay('show', {
          imagePosition: 'center center',
          maxSize: '75px'
      });

      require([
          'esri/layers/MapImageLayer'
      ], function(MapImageLayer) {

        if (!this.layers) {
            this.layers = {};
        }

        this.layers.FloodZoneLayer = new MapImageLayer({
            url: 'https://hazards.fema.gov/gis/nfhl/rest/services/public/NFHL/MapServer',
            opacity: 0.3,
            customParameters: {
                'format': 'PNG32',
                'layerIds': [28],
                'layerOption': 'show'
            }
        });

        this.map.allLayers.on('change', (event) => {
            if (event.added.length > 0) {
                event.added.forEach((layer) => {
                  console.log('layer(s) currently loaded: ' + layer.title);
                  container.LoadingOverlay('hide');
                });
            }
        });

        this.map.layers.add(this.layers.FloodZoneLayer);

    }.bind(this));
};

ArcGIS_v4_19.prototype.loadTransportationLayer = function () {

    require(['esri/layers/TileLayer'], function (TileLayer) {
        this.layers.TransportationLayer = new TileLayer(
            'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Transportation/MapServer',
            { id: 'streets' }
        );

        this.map.addLayer(this.layers.TransportationLayer);
    }.bind(this));
};

ArcGIS_v4_19.prototype.loadCentralBusinessDistrictLayer = function () {

    let container = $('[id$="map_canvas"]');

    require([
        'esri/layers/FeatureLayer',
        'esri/PopupTemplate',
        'esri/tasks/query'
    ], function (FeatureLayer, PopupTemplate, Query) {
        if (!this.layers) {
            this.layers = {};
        }
        //console.log('loading CBD layer');
        this.layers.CentralBusinessDistrictLayer = new FeatureLayer(
            'https://extgsagis.gsa.gov/extgsagis/rest/services/WorkSpaces/REIS/MapServer/0',
            {
                mode: FeatureLayer.MODE_ONDEMAND,
                outFields: ['*'],
                opacity: 0.3
            }
        );

        this.layers.CentralBusinessDistrictLayer.on('update-start', function (
            event
        ) {
            container.LoadingOverlay('show', {
                imagePosition: 'center center',
                maxSize: '75px'
            });
        });

        this.layers.CentralBusinessDistrictLayer.on('update-end', function (event) {
            container.LoadingOverlay('hide');
        });

        this.map.addLayer(this.layers.CentralBusinessDistrictLayer);

        let query = new Query();
        query.geometry = this.map.extent;
        query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
        query.returnGeometry = true;
        query.outFields = ['*'];

        this.layers.CentralBusinessDistrictLayer.queryFeatures(query, function (
            featureSet
        ) {
            for (let i = 0; i < featureSet.features.length; i) {
                let feature = featureSet.features[i];
                feature.geometry.clearCache();
                break;
            }
        });
    }.bind(this));
};

