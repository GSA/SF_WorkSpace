/**
 * If the Shape class hasn't been declared yet,
 * create it.
 */
if (typeof Shape !== 'function') {
  function Shape() {}
}

/**
 * Polygon class declaration.
 */
function _Polygon() {}

/**
 * Render method.
 */
_Polygon.prototype.render = function(shape) {
  require([
    'esri/geometry/Polygon',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleFillSymbol',
    'esri/Graphic',
    'esri/Color'
  ], function(Polygon, SimpleLineSymbol, SimpleFillSymbol, Graphic, Color) {

console.log('Starting polygon.render() function...');

    var coords = [];

    if (!shape) {
      var paths = AAAPGMAP.shapeData.polygon.paths;

      $.each(paths, function() {
        coords.push([parseFloat(this.lng), parseFloat(this.lat)]);
      });

      if (paths && paths.length > 0) {
        coords.push([parseFloat(paths[0].lng), parseFloat(paths[0].lat)]);
      }
    } else {
      coords = shape;
    }

    if (coords.length > 0) {
      var polygon = new Polygon(coords);

      AAAPGMAP.graphic = new Graphic(
        polygon,
        new SimpleFillSymbol(
          SimpleFillSymbol.STYLE_SOLID,
          new SimpleLineSymbol(
            SimpleLineSymbol.STYLE_SOLID,
            new Color([128, 0, 0]),
            2
          ),
          new Color([128, 0, 0, 0.25])
        )
      );

      AAAPGMAP.graphic.attributes = { shape: 'POLYGON' };

      AAAPGMAP.mapview.graphics.add(AAAPGMAP.graphic);
console.log('Added stored polygon to MapView.graphics: ' + JSON.stringify(AAAPGMAP.graphic));
      
      AAAPGMAP.mapview.center = polygon.centroid;         

console.log('About to set AAAPGMAP.mapview.extent equal to the polygon shape newly created from stored coordinates: ' + JSON.stringify(polygon));
      AAAPGMAP.mapview.extent = polygon.extent;
      //if (!AAAPGMAP.mapview.extent.contains(AAAPGMAP.graphic)) {
           //console.log('Expanding extent for graphic a little...');
      	AAAPGMAP.mapview.extent.expand(1.5);
      //}

    }
  });
};

/**
 * Render method.
 */
_Polygon.prototype.renderNoExpand = function(shape) {
  require([
    'esri/geometry/Polygon',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleFillSymbol',
    'esri/Graphic',
    'esri/Color'
  ], function(Polygon, SimpleLineSymbol, SimpleFillSymbol, Graphic, Color) {

console.log('Starting polygon.render() function...');

    var coords = [];

    if (!shape) {
      var paths = AAAPGMAP.shapeData.polygon.paths;

      $.each(paths, function() {
        coords.push([parseFloat(this.lng), parseFloat(this.lat)]);
      });

      if (paths && paths.length > 0) {
        coords.push([parseFloat(paths[0].lng), parseFloat(paths[0].lat)]);
      }
    } else {
      coords = shape;
    }

    if (coords.length > 0) {
      var polygon = new Polygon(coords);

      AAAPGMAP.graphic = new Graphic(
        polygon,
        new SimpleFillSymbol(
          SimpleFillSymbol.STYLE_SOLID,
          new SimpleLineSymbol(
            SimpleLineSymbol.STYLE_SOLID,
            new Color([128, 0, 0]),
            2
          ),
          new Color([128, 0, 0, 0.25])
        )
      );

      AAAPGMAP.graphic.attributes = { shape: 'POLYGON' };

      AAAPGMAP.mapview.graphics.add(AAAPGMAP.graphic);
console.log('Added stored polygon to MapView.graphics: ' + JSON.stringify(AAAPGMAP.graphic));
      
      AAAPGMAP.mapview.center = polygon.centroid;         

console.log('About to set AAAPGMAP.mapview.extent equal to the polygon shape newly created from stored coordinates: ' + JSON.stringify(polygon));
      //AAAPGMAP.mapview.extent = polygon.extent;
      //if (!AAAPGMAP.mapview.extent.contains(AAAPGMAP.graphic)) {
           //console.log('Expanding extent for graphic a little...');
      	//AAAPGMAP.mapview.extent.expand(1.5);
      //}

    }
  });
};

/**
 * Boundaries method.
 * TODO: Get extent of all graphics and center.
 */
_Polygon.prototype.boundaries = function(boundaries) {
  require([
    'esri/geometry/Polygon',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleFillSymbol',
    'esri/Graphic',
    'esri/Color'
  ], function(Polygon, SimpleLineSymbol, SimpleFillSymbol, Graphic, Color) {

console.log('Starting polygon.boundaries() function...');

    var extent;

    for (var i = 0; i < boundaries.length; i++) {
      var boundary = boundaries[i];

      var polygon = new Polygon(boundary);

      AAAPGMAP.graphic = new Graphic(
        polygon,
        new SimpleFillSymbol(
          SimpleFillSymbol.STYLE_SOLID,
          new SimpleLineSymbol(
            SimpleLineSymbol.STYLE_SOLID,
            new Color([128, 0, 0]),
            2
          ),
          new Color([128, 0, 0, 0.25])
        )
      );

      AAAPGMAP.graphic.attributes = { shape: 'POLYGON' };

      AAAPGMAP.map.graphics.add(AAAPGMAP.graphic);

      ext = AAAPGMAP.graphic.geometry.getExtent();

      if (extent) {
        extent.concat(ext);
      } else {
        extent = new esri.geometry.Extent(ext);
      }
    }

    AAAPGMAP.map.setExtent(extent, true);
  });
};

/**
 * Draw method.
 */
_Polygon.prototype.draw = function() {
  require([
    'esri/views/draw/Draw',
    'esri/symbols/SimpleFillSymbol',
    'esri/symbols/SimpleLineSymbol',
    'esri/Color',
    'esri/Graphic',
    'esri/layers/GraphicsLayer'
  ], function(Draw, SimpleFillSymbol, SimpleLineSymbol, Color, Graphic, GraphicsLayer) {

console.log('Starting polygon.draw() function...');

    $('#polyTd').css('font-weight', 'bold');
    $('#polyTd').css('background-color', 'silver');
    $('#circleTd').css('background-color', '#ffffff');
    $('#editTd').css('font-weight', 'normal');
    $('#editTd').css('background-color', '#ffffff');
    $('#undoTd').css('display', 'none');
    $('#draw_instructions').css('display', 'block');
    $('#edit_instructions').css('display', 'none');

    AAAPGMAP.mode = 'draw polygon';

    if (AAAPGMAP.edit) {
      AAAPGMAP.edit.deactivate();
    }

    var symbol = new SimpleFillSymbol(
      SimpleFillSymbol.STYLE_SOLID,
      new SimpleLineSymbol(
        SimpleLineSymbol.STYLE_SOLID,
        new Color([128, 0, 0]),
        2
      ),
      new Color([128, 0, 0, 0.25])
    );

    var draw = new Draw({
        view: AAAPGMAP.mapview
    });

    let action = draw.create('polygon');

    action.on('vertex-add', function(evt) {
        console.log('Caught vertex-add event, calling addPolygonPoint()...');
        //createPolygonGraphic(evt.vertices);
        addPolygonPoint(evt.vertices);
    });

    action.on('cursor-update', function(evt) {
        createPolygonGraphic(evt.vertices);
    });

    action.on('draw-complete', function(evt) {
        console.log('Caught draw-complete event, completing shape without adding point...');
        //createPolygonGraphic(evt.vertices);
        //addPolygonPointAndComplete(evt.vertices);
        AAAPGMAP.mapview.map.layers.removeAll();
    });

    function addPolygonPoint(vertices) {

       console.log('In addPolygonPoint() with vertices: ' + JSON.stringify(vertices));

       AAAPGMAP.mapview.graphics.removeAll();

       let polygon = {
            type: "polygon",
            rings: vertices,
            spatialReference: AAAPGMAP.mapview.spatialReference
        };

        let graphic = new Graphic({
            geometry: polygon,
            symbol: symbol 
        });

        AAAPGMAP.mapview.graphics.add(graphic);
        AAAPGMAP.graphic = graphic;

        console.log('Updated graphic: ' + JSON.stringify(AAAPGMAP.graphic));

    }

    function createPolygonGraphic(vertices) {

       AAAPGMAP.mapview.graphics.removeAll();

       let polygon = {
            type: "polygon",
            rings: vertices,
            spatialReference: AAAPGMAP.mapview.spatialReference
        };

        let graphic = new Graphic({
            geometry: polygon,
            symbol: symbol 
        });

        AAAPGMAP.mapview.graphics.add(graphic);
        AAAPGMAP.graphic = graphic;

    }

    function addPolygonPointAndComplete(vertices) {

       console.log('In addPolygonPointAndComplete() with vertices: ' + JSON.stringify(vertices));

       AAAPGMAP.mapview.graphics.removeAll();

       let polygon = {
            type: "polygon",
            rings: vertices,
            spatialReference: AAAPGMAP.mapview.spatialReference
        };

        let graphic = new Graphic({
            geometry: polygon,
            symbol: symbol 
        });

        AAAPGMAP.mapview.graphics.add(graphic);
        AAAPGMAP.graphic = graphic;

        console.log('Updated graphic: ' + JSON.stringify(AAAPGMAP.graphic));

    }


  });
};

/**
 * Add a new instance of the Polygon class
 * to the Shape class.
 */
Shape.prototype.polygon = new _Polygon();

