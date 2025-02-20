const METERTOMILE = 1609.344;
var AAAPGMAP = AAAPGMAP || {};

$(document).ready(function() {
  //Pull stored polygon shape from the Apex controller
  AAAPGMAP.shapeData = SF.Shape;
  console.log('Window width: ' + window.innerWidth);
  
  // Global instances once the files are loaded.
  shape = new Shape();
  drawing = new Drawing();

  // bind the shape name input field
  AAAPGMAP.pname = $('[id$="val_usr_del_area_name"]')[0];
  
  require([
        'esri/Map',
        'esri/views/MapView',
        //'esri/geometry/Multipoint',
        'esri/layers/GraphicsLayer'
    ], function(Map, MapView, GraphicsLayer) {    
      var lat,
      long,
      zoom,
      region = $('#txt_region_value').text();

    if (region === 'National Capital Region' || region === 'Region 11') {
      zoom = 9;
      lat = 38.8863175;
      long = -77.0241685;
    } else if (region === 'Region 4') {
      zoom = 9;
      lat = 33.7528113;
      long = -84.4099395;
    } else {
      zoom = 5;
      lat = 37.09;
      long = -95.71;
    }

    // Create new map and view instance.
    AAAPGMAP.map = new Map({
        basemap: 'topo-vector',
        layers: [new GraphicsLayer]
    });

    AAAPGMAP.mapview = new MapView({
        map: AAAPGMAP.map,
        container: $('[id$="map_canvas"]').attr('id'),
        zoom: zoom,
        center: [long, lat]
    })

console.log('Created basemap for region ' + region + ' with latitude ' + lat + ', longitude ' + long + ', and zoom ' + zoom);

      if (AAAPGMAP.shapeData && AAAPGMAP.shapeData.polygon) {
          shape.polygon.render();
          drawing.edit();
      }
  });

  $('#location-search-btn').on('click', function() {
    require([
      'esri/tasks/Locator'
    ], function(Locator) {
      new Locator(
'https://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer'
      )
        .addressToLocations({
          address: {
            SingleLine: $('#location-search-input').val()
          },
          outFields: ['*']
        })
        .then(function(candidates) {
          // Remove all graphics
          AAAPGMAP.mapview.graphics.removeAll(); 
          AAAPGMAP.mapview.map.layers.removeAll();
 
          // Create points on the map for all candidates and then set the extent based on points added to the map.
          const multipt = multipoint(candidates);

        })
        .catch(function(err) {
          console.error(err);
        });
    });
  });

  // is there a polygon to display?
  if (SF.Shape) {
    $('#btn_reset_shape').show();
    $('#btn_clear_shape').hide();
  } else {
    $('#btn_reset_shape').hide();
    $('#btn_clear_shape').show();
  } // end if
});

/**
 * Create and add all search result candidate points to the map.
 */
function multipoint(candidates) {

  require([
    'esri/geometry/Multipoint',
    'esri/geometry/Point',
    'esri/geometry/Extent',
    'esri/geometry/support/webMercatorUtils',
    'esri/symbols/SimpleMarkerSymbol',
    'esri/Graphic',
    'esri/PopupTemplate'
  ], function(Multipoint, Point, Extent, Utils, SimpleMarkerSymbol, Graphic, PopupTemplate) {

  // Create new multipoint.
  var multipoint = new Multipoint(
      AAAPGMAP.mapview.spatialReference
  );

  var countries = ['PRI', 'USA', 'VIR', 'GUM'];

  var address_types = [
    'SubAddress',
    'PointAddress',
    'StreetAddress',
    'StreetInt',
    'StreetAddressExt',
    'DistanceMarker',
    'StreetName',
    'Locality',
    'PostalLoc',
    'PostalExt',
    'Postal',
    'POI',
    'LatLong',
    'XY-XY',
    'YX-YX',
    'MGRS',
    'USNG'
  ];

  var address_type_index = 1000;
  var exact_match = false;

  // Loop through the candidates and find the most localized
  // address type.
  for (var i = 0; i < candidates.length; i++) {
    var candidate = candidates[i];
    // Only look at candidates with the following...
    if (
      // Candidate is in the United State or an associated territory... 
      countries.indexOf(candidate.attributes.Country) !== -1 &&
      // ...AND Candidate has a score of 100.
      candidate.attributes.Score === 100
    ) {
      var index = address_types.indexOf(candidate.attributes.Addr_type);

      // Find the most localized candidate. (lowest index)
      if (index !== -1 && index < address_type_index) {
        address_type_index = index;
      }

      // This candidates location is an exact match to
      // the search string.
      if (
        candidate.attributes.PlaceName.toLowerCase() ===
        candidate.attributes.Place_addr.toLowerCase()
      ) {
        exact_match = candidate;
        if (candidate.attributes.Addr_type === 'Locality') {
          outline_locality(candidate);
        }
      }
    }
  }

  // If an exact match was found, use it and ignore all
  // other candidates with similar address types.
  if (exact_match !== false) {
    candidates = [exact_match];
  }

  // Create and add as points all candidates with the most
  // localized address type that we found earlier.
  for (var i = 0; i < candidates.length; i++) {
    candidate = candidates[i];

    if (
      // Candidate is in the United State or an associated territory...
      countries.indexOf(candidate.attributes.Country) !== -1 &&
      // ...AND Candidate has a score of 100.
      candidate.attributes.Score === 100 &&
      // This candidate has a matching type.
      candidate.attributes.Addr_type === address_types[address_type_index]
    ) {

console.log('Creating a new point for next candidate match...');

      // Create a new point.
      var point = new Point({
        longitude: candidate.location.x,
        latitude: candidate.location.y
      });

      // Add a new point.
      multipoint.addPoint(point);

      var simpleMarkerSymbol = {
          type: "simple-marker",
          style: "circle",
          color: [255, 0, 0, 255],//red
          size: 10,
          outline: {  
              color: [0, 0, 0, 255], // black
              width: 1
          }
      }

      var address = candidate.attributes.LongLabel;
      // Configure attributes for info template.
      var attributes = {
        //address: candidate.attributes.LongLabel
        address: address
      };

      // Configure popup template.
      var template = new PopupTemplate({
        title: '{address}'
      });

      AAAPGMAP.mapview.graphics.add(new Graphic({
          geometry: point,
          symbol: simpleMarkerSymbol,
          attributes: attributes,
          popupTemplate: template
      }));

    } // end if
  } // end for loop

  // Use the multipoint to set extent on map.
    set_extent(multipoint, Point, Extent, Utils);

  });
}

/**
 * Set the map extent based on all the points in
 * the multipoint set.
 */
function set_extent(multipoint, point, extent, utils) {
  var points = multipoint.points;

  // There are no points.
  if (points.length === 0) {
    AAAPGMAP.mapview.extent = new extent({
        xmin: -14177690,
        ymin: 2618510,
        xmax: -7084330,
        ymax: 6532090,
        spatialReference: {
            wkid: 102100
        }
    });
    AAAPGMAP.mapview.zoom = 4;
  }

  // There is only one address.
  else if (points.length === 1) {
    AAAPGMAP.mapview.center = points[0];
    AAAPGMAP.mapview.zoom = 10;
  }

  // There are multiple addresses.
  else if (points.length > 1) {
    var plot = function(x, y) {
      var cartesian = utils.lngLatToXY(x, y);
      return { x: cartesian[0], y: cartesian[1] };
    };

    //var extent = multipoint.getExtent();
    var extent = multipoint.extent;

    var min = plot(extent.xmin, extent.ymin);
    var max = plot(extent.xmax, extent.ymax);

//TODO: Develop a new function to center and zoom by spinning through all points and deriving a center point and extent
    //AAAPGMAP.mapview.zoom = 6;

  }
}

/**
 * Draw the locality outline on the map.
 *
 * @param {*} candidate
 */
function outline_locality(candidate) {
  console.log('outline locality', candidate);
  var location = encodeURI(candidate.attributes.PlaceName);
  $.ajax({
    url:
      'https://nominatim.openstreetmap.org/search.php?q=' +
      location +
      '&polygon_geojson=1&format=json',
    success: function(response) {
      console.log(response);
      var candidates = [];
      for (var i = 0; i < response.length; i++) {
        if (
          parseFloat(candidate.location.y) <
            parseFloat(response[i].boundingbox[1]) &&
          parseFloat(candidate.location.y) >
            parseFloat(response[i].boundingbox[0]) &&
          parseFloat(candidate.location.x) <
            parseFloat(response[i].boundingbox[3]) &&
          parseFloat(candidate.location.x) >
            parseFloat(response[i].boundingbox[2])
        ) {
          candidates.push(response[i]);
        }
      }
      console.log('outline candidates', candidates);

      var shape = new Shape();

      for (var i = 0; i < candidates.length; i++) {
        shape.polygon.boundaries(candidates[i].geojson.coordinates);
      }
    }
  });
}

