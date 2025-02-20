function renderPolygon() {
  require([
    'esri/geometry/Polygon',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleFillSymbol',
    'esri/Graphic',
    'esri/Color',
    'dojo/domReady!'
  ], function(Polygon, SimpleLineSymbol, SimpleFillSymbol, Graphic, Color) {
    var coords = [];

    console.log('PBS_AAAP_IdentifyWinnerSearch_Polygon renderPolygon() starting. About to loop through shape.polygon.paths...');
    $.each(shape.polygon.paths, function(index) {
      console.log('pushing path onto coords, long: ' + this.lng + ', lat: ' + this.lat);
      coords.push([parseFloat(this.lng), parseFloat(this.lat)]);
    });

    console.log('pushing first path onto coords, long: ' + shape.polygon.paths[0].lng + ', lat: ' + shape.polygon.paths[0].lat);
    coords.push([
      parseFloat(shape.polygon.paths[0].lng),
      parseFloat(shape.polygon.paths[0].lat)
    ]);

    // The polygon has sides and can be drawn.
    if (coords.length > 0) {
      console.log('coords.length is ' + coords.length + ' so drawing the shape graphic...');
      var polygon = new Polygon([coords]);
      //console.log('New polygon created: ' + JSON.stringify(polygon));

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
      console.log('New graphic created: ' + JSON.stringify(AAAPGMAP.graphic));
      
      AAAPGMAP.graphic.attributes = { shape: 'POLYGON' };

      AAAPGMAP.mapview.graphics.add(AAAPGMAP.graphic);
      console.log('Added stored polygon to MapView.graphics: ' + JSON.stringify(AAAPGMAP.graphic));
      
      AAAPGMAP.mapview.center = polygon.centroid;         

      //console.log('About to set AAAPGMAP.mapview.extent equal to the polygon shape newly created from stored coordinates.');
      //AAAPGMAP.map.setExtent(polygon.getExtent(), true);
      AAAPGMAP.mapview.extent = polygon.extent.expand(1.5);

    }

  });
}
