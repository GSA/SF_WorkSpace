$(document).ready(function() {
  // Attach event handler for flood plain layer.
  $('#layer-flood').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      removeLayer('FloodZoneLayer');
    } else {
      $(this).addClass('active');
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

  // Attach event handler for seismic layer.
  $('#layer-lessor').on('click', function() {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      removeLayer('LessorLayer');
    } else {
      $(this).addClass('active');
      addLayer('LessorLayer');
    }
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
    case 'LessorLayer':
      loadLessorLayer();
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

  container.LoadingOverlay('show', {
    imagePosition: 'center center',
    maxSize: '75px'
  });

  require([
    'esri/layers/FeatureLayer',
    'esri/renderers/SimpleRenderer',
    'esri/Color',
    'esri/symbols/SimpleFillSymbol',
    'esri/symbols/SimpleLineSymbol',
    'esri/rest/query'
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

    AAAPGMAP.layers.CentralBusinessDistrictLayer.on('update-start', function(event) {

    });

    AAAPGMAP.layers.CentralBusinessDistrictLayer.on('update-end', function(event) {
      container.LoadingOverlay('hide');
    });

    AAAPGMAP.map.addLayer(AAAPGMAP.layers.CentralBusinessDistrictLayer);

    var query = new Query();
    query.geometry = AAAPGMAP.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    AAAPGMAP.layers.CentralBusinessDistrictLayer.queryFeatures(query, function(featureSet) {
      for (var i = 0; i < featureSet.features.length; i) {
        var feature = featureSet.features[i];
        feature.geometry.clearCache();
        break;
      }
    });
  });
}

/**
 * Load the Lessor Layer.
 */
function loadLessorLayer() {
  require([
    'esri/layers/FeatureLayer',
    'esri/PopupTemplate',
    'esri/rest/support/Query'
  ], function(FeatureLayer, PopupTemplate, Query) {
    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

    var container = $('[id$="map_canvas"]');
    container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
    });

    var popupTemplate = new PopupTemplate('<div style="height:0px;"></div>', '');

    AAAPGMAP.layers.LessorLayer = new FeatureLayer(
      'https://services1.arcgis.com/eBupDfPlEJK3mdAm/arcgis/rest/services/IOLP_NEW/FeatureServer/1',
      {
        mode: FeatureLayer.MODE_ONDEMAND,
        popupTemplate: popupTemplate,
        outFields: ['*'],
        opacity: 0.3
      }
    );

    //AAAPGMAP.layers.LessorLayer.on('update-end', function(event) {
    AAAPGMAP.layers.LessorLayer.on('layerview-create', function(event) {
      container.LoadingOverlay('hide');

      //var attributes = AAAPGMAP.layers.LessorLayer.graphics[0].attributes;
      //console.log('Lessor Layer attributes: ', attributes);

      var body = [
        'BUILDING_RSF',
        'CONGRESSIONAL_DISTRICT_CODE',
        'LEASE_EFFECTIVE_DATE',
        'LEASE_EXPIRATION_DATE',
        'LEASE_NUM',
        'LOC_CODE'
      ];

      for (i = 0; i < body.length; i++) {
        //body[i] = '<tr><td>' + body[i] + ':</td><td>${' + body[i] + '}</td></tr>';
        body[i] = '<tr><td>' + body[i] + ':</td><td>{' + body[i] + '}</td></tr>';
      }

      AAAPGMAP.layers.LessorLayer.popupTemplate.content =
        '<div class="lessor-layer-point">' +
          //'<div class="lessor-layer-point--address">${STREET_ADDRESS}, ${CITY}, ${STATE_CD} ${ZIPCODE5}</div>' +
          '<div class="lessor-layer-point--address">{STREET_ADDRESS}, {CITY}, {STATE_CD} {ZIPCODE5}</div>' +
          '<table class="lessor-layer-point--details">' +
          body.join('') +
          '</table>' +
          '</div>';
    });

    AAAPGMAP.map.layers.add(AAAPGMAP.layers.LessorLayer);

/*  commented out as it does not appear to be needed with version 4.23
    var query = new Query();
    query.geometry = AAAPGMAP.map.extent;
    query.spatialRelationship = Query.SPATIAL_REL_ENVELOPEINTERSECTS;
    query.returnGeometry = true;
    query.outFields = ['*'];

    AAAPGMAP.layers.LessorLayer.queryFeatures(query, function(featureSet) {
      for (var i = 0; i < featureSet.features.length; i) {
        var feature = featureSet.features[i];
        feature.geometry.clearCache();
        break;
      }
    });
*/

  });

}

/**
 * Load the Seismic Layer.
 */
function loadSeismicLayer() {
  var container = $('[id$="map_canvas"]');

  require([
    'esri/layers/FeatureLayer',
    'esri/InfoTemplate',
    'esri/rest/query'
  ], function(FeatureLayer, InfoTemplate, Query) {
    if (!AAAPGMAP.layers) {
      AAAPGMAP.layers = {};
    }

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
      container.LoadingOverlay('show', {
        imagePosition: 'center center',
        maxSize: '75px'
      });
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

function streetViewToggle() {
  AAAPGMAP.map.basemap = 'topo-vector';
  $('#streetTab').css('font-weight', 'bold');
  $('#satTab').css('font-weight', 'normal');
}

function satelliteViewToggle() {
  AAAPGMAP.map.basemap = 'hybrid';
  $('#satTab').css('font-weight', 'bold');
  $('#streetTab').css('font-weight', 'normal');
}
