function renderCircle(shape) {
  require([
    'esri/graphic',
    'esri/geometry/Circle',
    'esri/geometry/Point',
    'esri/symbols/SimpleFillSymbol',
    'dojo/domReady!'
  ], function(
    Graphic,
    Circle,
    Point,
    SimpleFillSymbol
  ) {
    var circle = new Circle(
      new Point([shape.circle.path.lng, shape.circle.path.lat]),
      {
        radius: shape.circle.radius,
        geodesic: true
      }
    );

    AAAPGMAP.map.graphics.add(
      new Graphic(
        circle,
        new SimpleFillSymbol({
          color: [80, 12, 0, 80],
          style: 'esriSFSSolid',
          outline: {
            color: [128, 12, 0, 128],
            width: 2
          }
        })
      )
    );

    AAAPGMAP.map.setExtent(circle.getExtent(), true);
  });
}
