var AAAP = AAAP ? AAAP : {};

AAAP.map = {
  container: null,
  service: null
};

/**
 * Initialize map.
 */
AAAP.map.initialize = function() {
  // Set map.
  this.container = $('[id$="map_canvas"]');

  this.container.hide();

  this.service = this.setService(this.container.attr('id'));

  // Initialize map service.
  this.getService()
    .init()
    .then(function(instance) {
      console.log('map service initialized', instance);
    })
    .catch(function(err) {
      console.log(err);
    });

  // Attach event handler for topo-vector view.
  $('#view-topo-vector').on(
    'click',
    function() {
      this.setView('topo-vector');
    }.bind(this)
  );

  // Attach event handler for hybrid view.
  $('#view-hybrid').on(
    'click',
    function() {
      this.setView('hybrid');
    }.bind(this)
  );

  // Attach event handler for flood plain layer.
  $('#layer-flood').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      AAAP.map.hideLayer('FloodZoneLayer');
    } else {
      $(this).addClass('active');
      AAAP.map.showLayer('FloodZoneLayer');
    }
  });

  // Attach event handler for seismic layer.
  $('#layer-seismic').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      AAAP.map.hideLayer('SeismicLayer');
    } else {
      $(this).addClass('active');
      AAAP.map.showLayer('SeismicLayer');
    }
  });

    // Attach event handler for seismic layer.
    $('#layer-cbd').on('click', function() {
      if ($(this).hasClass('active')) {
        $(this).removeClass('active');
        AAAP.map.hideLayer('CentralBusinessDistrictLayer');
      } else {
        $(this).addClass('active');
        AAAP.map.showLayer('CentralBusinessDistrictLayer');
      }
    });

  // Attach event handler for seismic layer.
  $('#layer-transit').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      AAAP.map.hideLayer('TransitLayer');
    } else {
      $(this).addClass('active');
      AAAP.map.showLayer('TransitLayer');
    }
  });
};


AAAP.map.setService = function(container) {
  console.log(SF_Label);
  return new ArcGIS_v3_29({
    container: container,
    locatorUrl: SF_Label.locator.WORLD,
    click: function(marker){
      var service = AAAP.map.getService();
      for (var key in service.markers) {
        if (key !== marker.id) {
          service.removeMarker(key);
        }
      }
      console.log('click marker', marker);
      AAAP.table.initialize(marker.location);
    }
  });
};

AAAP.map.getService = function() {
  return this.service;
};

/**
 *
 */
AAAP.map.setView = function(view) {
  this.service.setView(view);

  switch(view){
    case 'hybrid' : this.service.addLayer('TransportationLayer'); break;
    default : 
      this.service.removeLayer('TransportationLayer');
  }

  $('.map--view-item').css('font-weight', 'normal');
  $('#view-' + view).css('font-weight', 'bold');
};

AAAP.map.showLayer = function(layer) {
  this.service.addLayer(layer);
};

AAAP.map.hideLayer = function(layer) {
  this.service.removeLayer(layer);
};

/**
 *
 */
/*
AAAP.map.getMetroData = function(lat, lng) {
  require([
    "esri/tasks/Geoprocessor",
    "esri/geometry/webMercatorUtils"
  ], function(Geoprocessor, WebMercatorUtils) {
    var latLngXY = WebMercatorUtils.lngLatToXY(lng, lat);
    var inputLocation = {
      displayFieldName: "",
      geometryType: "esriGeometryPoint",
      spatialReference: {
        wkid: 102100
      },
      fields: [
        {
          name: "OBJECTID",
          type: "esriFieldTypeOID",
          alias: "OBJECTID"
        }
      ],
      features: [
        {
          attributes: {
            OBJECTID: "1"
          },
          geometry: {
            x: latLngXY[0],
            y: latLngXY[1]
          }
        }
      ],
      exceededTransferLimit: false
    };
    var bufferDistance = {
      distance: 0.75,
      units: "esriMiles"
    };
    var paramsGP = {
      Input_Features: JSON.stringify(inputLocation),
      Buffer_Distance: JSON.stringify(bufferDistance)
    };

    esri.config.defaults.io.timeout = 300000;

    new Geoprocessor(SF_Label.locatorUrl).execute(
      paramsGP,
      function(results) {
        var distanceMeter =
          results[1].value.features[0].attributes.Total_Kilometers * 1000;
        console.log(
          "KM: " +
            JSON.stringify(
              results[1].value.features[0].attributes.Total_Kilometers
            )
        );
        if (distanceMeter <= METERTHRESHOLD) {
          AAAP.map.closeToMetro = true;
        }
        refresh(
          AAAP.form.location.street,
          AAAP.form.location.city,
          AAAP.form.location.state,
          AAAP.form.location.zip,
          AAAP.form.location.lat,
          AAAP.form.location.lng,
          AAAP.map.closeToMetro
        );
      },
      function(err) {
        refresh(
          AAAP.form.location.street,
          AAAP.form.location.city,
          AAAP.form.location.state,
          AAAP.form.location.zip,
          AAAP.form.location.lat,
          AAAP.form.location.lng,
          AAAP.map.closeToMetro
        );
        console.log("No Results from Metro Service: " + err.message);
      }
    ); //end execute
  }); //end require
};
*/
