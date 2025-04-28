/**
 * NOTE: Many esri classes are available directly but there
 * are a few that have to be implicitly required to work for
 * some reason. Notably, any class at the root level seems
 * to require being implicitly required.
 */

/**
 * ArcGIS JS API v3.29 Class
 *
 * @param {*} config
 */
function ArcGIS_v3_29(config) {
  this.config = config;
  this.map = undefined;
  this.multipoint = undefined;
  this.points = {
    loading: 0
  };
  this.markers = {};
  this.layers = {};
}

/**
 * Initialize the map.
 */
ArcGIS_v3_29.prototype.init = function() {
  var self = this;

  return new Promise(function(resolve, reject) {
    require([
      'esri/config',
      'esri/urlUtils',
      'esri/map',
      'esri/geometry/webMercatorUtils',
      'esri/tasks/locator'
    ], function(Config, Utils, Map, webMercatorUtils, Locator) {
      self.Config = Config;
      self.webMercatorUtils = webMercatorUtils;

      Utils.addProxyRule({
        urlPrefix: SF_Label.urlPrefix,  // 'https://extgsagis.gsa.gov',
        proxyUrl: SF_Label.proxyUrl     // 'https://aaapextsb.pbs.gsa.gov/proxy/proxy.ashx'
      });

      // Create / Config new map instance.
      self.map = new Map(self.config.container, {
        basemap: 'topo-vector',
        zoom: 4,
        extent: new esri.geometry.Extent({
          xmin: -14177690,
          ymin: 2618510,
          xmax: -7084330,
          ymax: 6532090,
          spatialReference: {
            wkid: 102100
          }
        })
      });

      self.map.on('dbl-click', function(evt) {
        // Execute a reverse geocode using the clicked location
        new Locator(
          //'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GeoLocate/GeocodeServer'
          //'https://extgsagis.gsa.gov/extgsagis/rest/services/GSA/GSA_USA/GeocodeServer'
          //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
          self.config.locatorUrl
        ).locationToAddress(evt.mapPoint, 0, function(response) {
          // Now that we have the address, we can create a marker and display it.
          self
            .addMarker(response.address.Match_addr, evt)
            .then(function(marker) {
              // Callback for the map click event.
              // When creating an instance of this class, you will create
              // a click method on the config object which provides the
              // newly created marker.
              if (self.config.click) {
                self.config.click(marker);
              }
            })
            .catch(function(err) {
              console.error(err);
            });
        });
      });

      // Map load event handler.
      self.map.on('load', function(evt) {
        if (evt.target.loaded === true) {
          // Initialize the multipoint.
          self.multipoint = new esri.geometry.Multipoint(
            self.map.spatialReference
          );

          // Load all the layers.
          self.loadAllLayers();

          // Resolve the promise.
          resolve(self);
        } else {
          reject(evt);
        }
      });
    });
  });
};

/**
 *
 */
ArcGIS_v3_29.prototype.getLocatorUrlByState = function(state) {
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

ArcGIS_v3_29.prototype.moveMarker = function(address, location) {
  return new Promise(function(resolve, reject){
    var coordinates = {
      longitude: location.lon,
      latitude: location.lat
    };

    var marker = this.createMarker(coordinates, address);
    console.log('marker', marker);
    // Add a new point to the map.
    this.map.graphics.add(marker);

    this.setExtent();

    var markerID = 'm' + (Math.random() * 1e32).toString(36);

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

/**
 * Add a single marker to the map.
 *
 * @param address
 */
ArcGIS_v3_29.prototype.addMarker = function(address, evt) {
  console.log('add marker', address);
  var content = function(lat, lon) {
    return (
      '<div><b>Latitude:</b> ' +
      lat +
      '</div>' +
      '<div><b>Longitude:</b> ' +
      lon +
      '</div>'
    );
  };

  return new Promise(
    function(resolve, reject) {
      this.points.loading++;
      this.addressToCoordinates(address)
        .then(
          function(locations) {
            console.log('add marker', locations);
            var coordinates = {
              longitude: locations[0].attributes.DisplayX,
              latitude: locations[0].attributes.DisplayY
            };
            var location = locations[0].attributes;

            if (evt) {
              coordinates = this.cartesianToGeolocation(
                evt.mapPoint.x,
                evt.mapPoint.y
              );

              this.map.infoWindow.setTitle(address);
              this.map.infoWindow.setContent(
                content(coordinates.latitude, coordinates.longitude)
              );

              this.map.infoWindow.show(
                evt.screenPoint,
                this.map.getInfoWindowAnchor(evt.screenPoint)
              );
            }

            this.points.loading--;
            var marker = this.createMarker(coordinates, address);
            // Add a new point to the map.
            this.map.graphics.add(marker);

            if (this.points.loading === 0) {
              // Reset the map extent.
              this.setExtent();
            }

            var markerID = 'm' + (Math.random() * 1e32).toString(36);

            this.markers[markerID] = marker;

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
                geometry: marker.geometry
              }
            });
          }.bind(this)
        )
        .catch(function(err) {
          reject(err);
        });
    }.bind(this)
  );
};

/**
 * Remove a single marker from the map.
 */
ArcGIS_v3_29.prototype.removeMarker = function(markerID) {
  var marker = this.markers[markerID];
  this.map.graphics.remove(marker);
  this.multipoint.removePoint(marker.geometry);
};

/**
 * Create a single map marker. This simply creates the
 * marker.  It still needs added to both the map and the
 * multipoint set of points.
 *
 * @param coordinates
 * @param attributes
 */
ArcGIS_v3_29.prototype.createMarker = function(coordinates, address) {
  // Create a new point.
  var point = new esri.geometry.Point(coordinates);

  // Add the point to the point set.
  this.multipoint.addPoint(point);

  // Create a new marker symbol.
  var symbol = new esri.symbol.SimpleMarkerSymbol({
    color: [255, 0, 0, 255], // red
    size: 10,
    angle: -30,
    xoffset: 0,
    yoffset: 0,
    type: 'esriSMS',
    outline: {
      color: [0, 0, 0, 255], // black
      width: 1,
      type: 'esriSLS',
      style: 'esriSLSSolid'
    }
  });

  var attributes = {
    address: address
  };

  var template = new esri.InfoTemplate({
    title: '${address}'
  });

  // Return the point graphic to display on map.
  return new esri.Graphic(point, symbol, attributes, template);
};

/**
 *
 * @param address
 */
ArcGIS_v3_29.prototype.suggest = function(location) {
  var map = this.map;
  var config = this.config;

  if (location.singleLineAddress && location.singleLineAddress.length > 0) {
    var params = {
      text: location.singleLineAddress,
      categories: ["Subaddress", "Point Address","Street Address"],
      location: map.extent.getCenter().normalize(),
      minCharacters: 4,
					 
      maxSuggestions: 10
    };

    return new Promise(function(resolve, reject) {
      require(['esri/tasks/locator'], function(Locator) {
        new Locator(
          //'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GeoLocate/GeocodeServer'
          //'https://extgsagis.gsa.gov/extgsagis/rest/services/GSA/GSA_USA/GeocodeServer'
          //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
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
  } else if (
    location.lat &&
    location.lat.length > 0 &&
    location.lon &&
    location.lon.length > 0
  ) {
    return new Promise(function(resolve, reject) {
      require([
        'esri/geometry/Point',
        'esri/tasks/locator'
      ], function(Point, Locator) {
        var point = new Point(
          parseFloat(location.lat),
          parseFloat(location.lon)
        );

        new Locator(
          //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
          config.locatorUrl
        )
          .locationToAddress(point)
          .then(function(response) {
            resolve([
              {
                address: response.address.LongLabel,
                parts: {
                  street: response.address.StAddr,
                  city: response.address.City,
                  state: response.address.Region,
                  zip: response.address.Postal
                }
              }
            ]);
          })
          .catch(function(err) {
            reject(err);
          });
      });
    });
  }
};

/**
 *
 */
ArcGIS_v3_29.prototype.search = function(location) {
  if (location.singleLineAddress && location.singleLineAddress.length > 0) {
    return new Promise(
      function(resolve, reject) {
        this.addMarker(location.singleLineAddress)
          .then(function(marker) {
            resolve(marker);
          })
          .catch(function(error) {
            reject(error);
          });
      }.bind(this)
    );
  } else if (
    location.lat &&
    location.lat.length > 0 &&
    location.lon &&
    location.lon.length > 0
  ) {
    console.log('search location', location);
    return new Promise(
      function(resolve, reject) {
        this.coordinatesToAddress(location.lon, location.lat)
          .then(
            function(res) {
              console.log('search', res);
              this.addMarker(res.address.LongLabel)
                .then(function(marker) {
                  resolve(marker);
                })
                .catch(function(error) {
                  reject(error);
                });
            }.bind(this)
          )
          .catch(function(error) {
            console.log('search error', error);
            reject(error);
          });
      }.bind(this)
    );
  } else {
    return new Promise(function(resolve, reject) {
      reject(false);
    });
  }
};

/**
 * Converts a longitude / latitude pair to an address.
 *
 * @param lon
 * @param lat
 */
ArcGIS_v3_29.prototype.coordinatesToAddress = function(lon, lat) {
  var config = this.config;

  return new Promise(function(resolve, reject) {
    require(['esri/tasks/locator'], function(Locator) {
      new Locator(
        //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
        config.locatorUrl
      )
        .locationToAddress(
          new esri.geometry.Point({
            longitude: lon,
            latitude: lat
          })
        )
        .then(function(res) {
          resolve(res);
        })
        .catch(function(err) {
          reject(err);
        });
    });
  });
};

/**
 * Converts an address to a set of geocodes (longitude, latitude).
 *
 * @param address
 */
ArcGIS_v3_29.prototype.addressToCoordinates = function(address) {
  var config = this.config;

  return new Promise(function(resolve, reject) {
    require(['esri/tasks/locator'], function(Locator) {
      new Locator(
        //'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
        config.locatorUrl
      )
        .addressToLocations({
          address: {
            SingleLine: address
          },
          outFields: ['*']
        })
        .then(function(res) {
          resolve(res);
        })
        .catch(function(err) {
          reject(err);
        });
    });
  });
};

/**
 * Setting the extent means that we are centering the map around
 * a set of points and then zooming in as close as possible with
 * all points showing on the map.
 */
ArcGIS_v3_29.prototype.setExtent = function() {
  var points = this.multipoint.points;

  if (points.length === 0) {
    this.map.setExtent(
      new esri.geometry.Extent({
        xmin: -14177690,
        ymin: 2618510,
        xmax: -7084330,
        ymax: 6532090,
        spatialReference: {
          wkid: 102100
        }
      }),
      true
    );
    this.map.setZoom(4);
  }

  // There is only one address.
  else if (points.length === 1) {
    this.map.centerAndZoom(
      new esri.geometry.Point({
        longitude: points[0][0],
        latitude: points[0][1]
      }),
      18
    );
  }

  // There are multiple addresses.
  else if (points.length > 1) {
    var extent = this.multipoint.getExtent();
    var min = this.geolocationToCartesian(extent.xmin, extent.ymin);
    var max = this.geolocationToCartesian(extent.xmax, extent.ymax);

    this.map.setExtent(
      new esri.geometry.Extent({
        xmin: min.x,
        ymin: min.y,
        xmax: max.x,
        ymax: max.y,
        spatialReference: {
          wkid: 102100
        }
      }),
      true
    );
  }
};

/**
 *
 */
ArcGIS_v3_29.prototype.cartesianToGeolocation = function(x, y) {
  var coordinates = this.webMercatorUtils.xyToLngLat(x, y);
  return { longitude: coordinates[0], latitude: coordinates[1] };
};

/**
 * Converts latitude and longitude into x and y cartesian coordinates.
 *
 * @param lon
 * @param lat
 */
ArcGIS_v3_29.prototype.geolocationToCartesian = function(lon, lat) {
  var cartesian = this.webMercatorUtils.lngLatToXY(lon, lat);
  return { x: cartesian[0], y: cartesian[1] };
};

/**
 *
 */
ArcGIS_v3_29.prototype.setView = function(view) {
  this.map.setBasemap(view);
};

/**
 * Load all the map layers.  This creates the layers.  It doesn't
 * add them to the map.
 */
ArcGIS_v3_29.prototype.loadAllLayers = function() {
  console.log('Layers', [
    'FloodZoneLayer',
    'SeismicLayer',
    'TransportationLayer',
    'CongressionalDistrictLayer'
  ]);

  this.addLayer('CongressionalDistrictLayer');
};

/**
 * Add the requested layer.
 *
 * @param layer
 */
ArcGIS_v3_29.prototype.addLayer = function(layer) {
  console.log('add layer', layer);
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

/**
 * Remove the selected layer.
 *
 * @param layer
 */
ArcGIS_v3_29.prototype.removeLayer = function(layer) {
  if (this.layers[layer]) {
    this.map.removeLayer(this.layers[layer]);
    delete this.layers[layer];
  }
};

/**
 * Load the Congressional District Layer.
 */
ArcGIS_v3_29.prototype.loadCongressionalDistrictLayer = function() {
  require(['esri/layers/FeatureLayer', 'esri/tasks/query'], function(
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
      function(event) {
        var query = new Query();
        query.geometry = this.map.extent;
        query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
        query.returnGeometry = true;
        query.outFields = ['*'];

        this.layers.CongressionalDistrictLayer.queryFeatures(
          query,
          function(featureSet) {
            this.congressionalDistricts = featureSet.features;
            console.log('congressional districts', this.congressionalDistricts);
            for (var i = 0; i < featureSet.features.length; i++) {
              var feature = featureSet.features[i];
              feature.geometry.clearCache();
              break;
            }
          }.bind(this)
        );
      }.bind(this)
    );

    this.map.addLayer(this.layers.CongressionalDistrictLayer);
  }.bind(this));
};

/**
 * Load the Flood Zone Layer.
 */
ArcGIS_v3_29.prototype.loadSeismicLayer = function() {
  var container = $('[id$="map_canvas"]');

  require([
    'esri/layers/FeatureLayer',
    'esri/InfoTemplate',
    'esri/tasks/query'
  ], function(FeatureLayer, InfoTemplate, Query) {
    var infoTemplate = new InfoTemplate('Attributes', '${*}');

    this.layers.SeismicLayer = new FeatureLayer(
      'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GSA_Seismic_Layer/MapServer/0',
      {
        mode: FeatureLayer.MODE_ONDEMAND,
        infoTemplate: infoTemplate,
        outFields: ['*'],
        opacity: 0.3
      }
    );

    this.map.addLayer(this.layers.SeismicLayer);

    this.layers.SeismicLayer.on('update-start', function(event) {
      container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
      });
    });

    this.layers.SeismicLayer.on('update-end', function() {
      container.LoadingOverlay('hide');
    });

    var query = new Query();
    query.geometry = this.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    this.layers.SeismicLayer.queryFeatures(query, function(featureSet) {
      for (var i = 0; i < featureSet.features.length; i) {
        var feature = featureSet.features[i];
        feature.geometry.clearCache();
        break;
      }
    });
  }.bind(this));
};

/**
 * Load the Flood Zone Layer.
 */
ArcGIS_v3_29.prototype.loadFloodZoneLayer = function() {
  var container = $('[id$="map_canvas"]');

  require([
    'esri/layers/ArcGISDynamicMapServiceLayer',
    'esri/layers/ImageParameters'
  ], function(ArcGISDynamicMapServiceLayer, ImageParameters) {
    var imageParameters = new ImageParameters();
    imageParameters.format = 'PNG32'; //set the image type to PNG24, note default is PNG8.
    imageParameters.layerIds = [28];
    imageParameters.layerOption = ImageParameters.LAYER_OPTION_SHOW;

    this.layers.FloodZoneLayer = new ArcGISDynamicMapServiceLayer(
      'https://hazards.fema.gov/gis/nfhl/rest/services/public/NFHL/MapServer',
      {
        opacity: 0.3,
        imageParameters: imageParameters
      }
    );

    this.layers.FloodZoneLayer.on('update-start', function(event) {
      container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
      });
    });

    this.layers.FloodZoneLayer.on('update-end', function() {
      container.LoadingOverlay('hide');
    });

    this.map.addLayer(this.layers.FloodZoneLayer);
  }.bind(this));
};

/**
 *
 */
ArcGIS_v3_29.prototype.loadTransportationLayer = function() {
  require(['esri/layers/ArcGISTiledMapServiceLayer'], function(TileLayer) {
    this.layers.TransportationLayer = new TileLayer(
      'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Transportation/MapServer',
      { id: 'streets' }
    );

    this.map.addLayer(this.layers.TransportationLayer);
  }.bind(this));
};

/**
 * Load the Central Business District layer
 */
ArcGIS_v3_29.prototype.loadCentralBusinessDistrictLayer = function() {
  var container = $('[id$="map_canvas"]');

  require([
    'esri/layers/FeatureLayer',
    'esri/InfoTemplate',
    'esri/tasks/query'
  ], function(FeatureLayer, InfoTemplate, Query) {
    if (!this.layers) {
      this.layers = {};
    }
    console.log('loading CBD layer');
    this.layers.CentralBusinessDistrictLayer = new FeatureLayer(
      'https://extgsagis.gsa.gov/extgsagis/rest/services/WorkSpaces/REIS/MapServer/0',
      {
        mode: FeatureLayer.MODE_ONDEMAND,
        outFields: ['*'],
        opacity: 0.3
      }
    );

    this.layers.CentralBusinessDistrictLayer.on('update-start', function(
      event
    ) {
      container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
      });
    });

    this.layers.CentralBusinessDistrictLayer.on('update-end', function(event) {
      container.LoadingOverlay('hide');
    });

    this.map.addLayer(this.layers.CentralBusinessDistrictLayer);

    var query = new Query();
    query.geometry = this.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    this.layers.CentralBusinessDistrictLayer.queryFeatures(query, function(
      featureSet
    ) {
      for (var i = 0; i < featureSet.features.length; i) {
        var feature = featureSet.features[i];
        feature.geometry.clearCache();
        break;
      }
    });
  }.bind(this));
};
