function renderPolygon() {
  require([
    'esri/geometry/Polygon',
    'esri/symbols/SimpleLineSymbol',
    'esri/symbols/SimpleFillSymbol',
    'esri/graphic',
    'esri/Color',
    'dojo/domReady!'
  ], function(Polygon, SimpleLineSymbol, SimpleFillSymbol, Graphic, Color) {
    var coords = [];

    $.each(shape.polygon.paths, function(index) {
      coords.push([parseFloat(this.lng), parseFloat(this.lat)]);
    });

    coords.push([
      parseFloat(shape.polygon.paths[0].lng),
      parseFloat(shape.polygon.paths[0].lat)
    ]);

    // The polygon has sides and can be drawn.
    if (coords.length > 0) {
      var polygon = new Polygon([coords]);

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
      AAAPGMAP.map.setExtent(polygon.getExtent(), true);
    }
  });
}
