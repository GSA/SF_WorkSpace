$(document).ready(function() {
  // Attach event handler for flood plain layer.
  $('#layer-flood').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $('#layer-flood').css('font-weight', 'normal');
      $('#layer-flood').css('background-color', '#ffffff');
      removeLayer('FloodZoneLayer');
    } else {
      $(this).addClass('active');
      $('#layer-flood').css('font-weight', 'bold');
      $('#layer-flood').css('background-color', 'silver');
      addLayer('FloodZoneLayer');
    }
  });

  // Attach event handler for seismic layer.
  $('#layer-seismic').on('click', function() {
    //if ($(this).hasClass('active')) {
    //  $(this).removeClass('active');
    //  removeLayer('SeismicLayer');
    //} else {
    //  $(this).addClass('active');
    //  addLayer('SeismicLayer');
    //}
  });

  // Attach event handler for central business district layer.
  $('#layer-cbd').on('click', function() {
    //if ($(this).hasClass('active')) {
    //  $(this).removeClass('active');
    //  removeLayer('CentralBusinessDistrictLayer');
    //} else {
    //  $(this).addClass('active');
    //  addLayer('CentralBusinessDistrictLayer');
    //}
  });

  // Attach event handler for seismic layer.
  $('#layer-transit').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      removeLayer('TransitLayer');
    } else {
      $(this).addClass('active');
      addLayer('TransitLayer');
    }
  });
});

/**
 * Add the requested layer.
 *
 * @param layer
 */
function addLayer(layer) {
  switch (layer) {
    case 'FloodZoneLayer':
      loadFloodZoneLayer();
      break;
    case 'SeismicLayer':
      loadSeismicLayer();
      break;
    case 'TransportationLayer':
      loadTransportationLayer();
      break;
    case 'CentralBusinessDistrictLayer':
      loadCentralBusinessDistrictLayer();
      break;
  }
}

/**
 * Remove the selected layer.
 *
 * @param layer
 */
function removeLayer(layer) {
  if (AAAPGMAP.layers[layer]) {
    AAAPGMAP.map.layers.remove(AAAPGMAP.layers[layer]);
    delete AAAPGMAP.layers[layer];
  }
}

/**
 * Load the Central Business District layer
 */
function loadCentralBusinessDistrictLayer() {
  var container = $('[id$="map_canvas"]');

  require([
    'esri/layers/FeatureLayer',
    'esri/renderers/SimpleRenderer',
    'esri/Color',
    'esri/symbols/SimpleFillSymbol',
    'esri/symbols/SimpleLineSymbol',
    'esri/tasks/query'
  ], function(
    FeatureLayer,
    SimpleRenderer,
    Color,
    SimpleFillSymbol,
    SimpleLineSymbol,
    Query
  ) {
    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

    var renderer = new SimpleRenderer(
      new SimpleFillSymbol().setOutline(
        new SimpleLineSymbol()
          .setWidth(2)
          .setColor(new Color([128, 128, 128]))
      )
    );

    AAAPGMAP.layers.CentralBusinessDistrictLayer = new FeatureLayer(
      //'https://extgsagis.gsa.gov/extgsagis/rest/services/WorkSpaces/REIS/MapServer/0',
      SF_Label.locator.CBD,
      {
        mode: FeatureLayer.MODE_ONDEMAND,
        outFields: ['*'],
        opacity: 1
      }
    );

    AAAPGMAP.layers.CentralBusinessDistrictLayer.setRenderer(renderer);

    AAAPGMAP.layers.CentralBusinessDistrictLayer.on('update-start', function() {
      container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
      });
    });

    AAAPGMAP.layers.CentralBusinessDistrictLayer.on('update-end', function() {
      container.LoadingOverlay('hide');
    });

    AAAPGMAP.map.addLayer(AAAPGMAP.layers.CentralBusinessDistrictLayer);

    var query = new Query();
    query.geometry = AAAPGMAP.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    AAAPGMAP.layers.CentralBusinessDistrictLayer.queryFeatures(query, function(
      featureSet
    ) {
      for (var i = 0; i < featureSet.features.length; i) {
        featureSet.features[i].geometry.clearCache();
        break;
      }
    });
  });
}

/**
 * Load the Seismic Layer.
 */
function loadSeismicLayer() {
  var container = $('[id$="map_canvas"]');

  container.LoadingOverlay('show', {
    imagePosition: 'center center',
    maxSize: '75px'
  });

  require([
    'esri/layers/FeatureLayer',
    'esri/InfoTemplate',
    'esri/tasks/query'
  ], function(FeatureLayer, InfoTemplate, Query) {
    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

    console.log('loading seismic layer');
    var infoTemplate = new InfoTemplate('Attributes', '${*}');

    AAAPGMAP.layers.SeismicLayer = new FeatureLayer(
      'https://extgsagis.gsa.gov/extgsagis/rest/services/Base/GSA_Seismic_Layer/MapServer/0',
      {
        mode: FeatureLayer.MODE_ONDEMAND,
        infoTemplate: infoTemplate,
        outFields: ['*'],
        opacity: 0.3
      }
    );

    AAAPGMAP.layers.SeismicLayer.on('update-start', function(event) {
      container.LoadingOverlay('hide');
      container.LoadingOverlay('show');
    });

    AAAPGMAP.layers.SeismicLayer.on('update-end', function(event) {
      container.LoadingOverlay('hide');
    });

    AAAPGMAP.map.addLayer(AAAPGMAP.layers.SeismicLayer);

    var query = new Query();
    query.geometry = AAAPGMAP.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    AAAPGMAP.layers.SeismicLayer.queryFeatures(query, function(featureSet) {
      for (var i = 0; i < featureSet.features.length; i) {
        var feature = featureSet.features[i];
        feature.geometry.clearCache();
        break;
      }
    });
  });
}

/**
 * Load the Flood Zone Layer.
 */
function loadFloodZoneLayer() {
  var container = $('[id$="map_canvas"]');

  container.LoadingOverlay('show', {
    imagePosition: 'center center',
    maxSize: '75px'
  });

  require([
      'esri/layers/MapImageLayer'
  ], function(MapImageLayer) {

    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

    AAAPGMAP.layers.FloodZoneLayer = new MapImageLayer({
        url: 'https://hazards.fema.gov/gis/nfhl/rest/services/public/NFHL/MapServer',
        opacity: 0.3,
        customParameters: {
            'format': 'PNG32',
            'layerIds': [28],
            'layerOption': 'show'
        }
    });

    AAAPGMAP.map.allLayers.on('change', (event) => {
        if (event.added.length > 0) {
            event.added.forEach((layer) => {
              console.log('flood layer loaded, title: ' + layer.title);
              container.LoadingOverlay('hide');
            });
        }
    });

    AAAPGMAP.map.layers.add(AAAPGMAP.layers.FloodZoneLayer);

    // Flood zones are not shown below zoom 13 so perform the setExtent() function to set apporpriate focus.
    //AAAPGMAP.setExtent();

  });
}

/**
 *
 */
function loadTransportationLayer() {
  require(['esri/layers/ArcGISTiledMapServiceLayer'], function(TileLayer) {
    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

    AAAPGMAP.layers.TransportationLayer = new TileLayer(
      'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Transportation/MapServer',
      { id: 'streets' }
    );

    AAAPGMAP.map.addLayer(AAAPGMAP.layers.TransportationLayer);
  });
}

/**
 *
 */
function streetViewToggle() {
  AAAPGMAP.map.basemap = 'topo-vector';
  $('#streetTab').css('font-weight', 'bold');
  $('#streetTab').css('background-color', 'silver');
  $('#satTab').css('font-weight', 'normal');
  $('#satTab').css('background-color', '#ffffff');
} //end streetViewToggle

/**
 *
 */
function satelliteViewToggle() {
  AAAPGMAP.map.basemap = 'hybrid';
  $('#satTab').css('font-weight', 'bold');
  $('#satTab').css('background-color', 'silver');
  $('#streetTab').css('font-weight', 'normal');
  $('#streetTab').css('background-color', '#ffffff');
} // satelliteViewToggle

AAAPGMAP.setExtent = function() {

  if (SF.Shape) {
    var zoom = AAAPGMAP.mapview.zoom < 13 ? 13 : AAAPGMAP.mapview.zoom;

    var geolocationToCartesian = function(lon, lat) {
      var cartesian = AAAPGMAP.webMercatorUtils.lngLatToXY(lon, lat);
      return { x: cartesian[0], y: cartesian[1] };
    };

    //if (points.length === 0) {
    if (typeof AAAPGMAP.multipoint.points === 'undefined' ||
        points.length === 0) {
      AAAPGMAP.mapview.zoom = zoom;
    }

    // There is only one address.
    else if (points.length === 1) {
      AAAPGMAP.map.centerAndZoom(
        new esri.geometry.Point({
          longitude: points[0][0],
          latitude: points[0][1]
        }),
        zoom
      );
    }

    // There are multiple addresses.
    else if (points.length > 1) {
      var extent = AAAPGMAP.multipoint.getExtent();
      var min = geolocationToCartesian(extent.xmin, extent.ymin);
      var max = geolocationToCartesian(extent.xmax, extent.ymax);

      AAAPGMAP.map.setExtent(
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
  }
};

