function renderMap() {
    require([
      'esri/map',
      'esri/geometry/Point',
      'esri/geometry/webMercatorUtils',
      'esri/symbols/SimpleMarkerSymbol',
      'esri/symbols/SimpleLineSymbol',
      'esri/graphic',
      'esri/Color',
      'esri/urlUtils',
      'esri/tasks/query',
      'dojo/domReady!'
    ], function(
      Map,
      Point,
      webMercatorUtils,
      SimpleMarkerSymbol,
      SimpleLineSymbol,
      Graphic,
      Color,
      Utils,
      Query
    ) {
      AAAPGMAP.webMercatorUtils = webMercatorUtils;
  
      var container = $('[id$="map_canvas"]')[0];
  
      $(container).show();
  
      AAAPGMAP.map = new Map(container, {
        center: [-84.409939, 33.7528113],
        zoom: 8,
        basemap: 'topo-vector'
      });
  
      Utils.addProxyRule({
        urlPrefix: SF_Label.urlPrefix,  // 'https://extgsagis.gsa.gov',
        proxyUrl: SF_Label.proxyUrl     // 'https://aaapintsb.pbs.gsa.gov/proxy/proxy.ashx'
      });
  
      AAAPGMAP.map.on('load', function() {
        var polygonOnMap = false;
  
        //console.log('JK shape ' + JSON.stringify(shape));//this shape is the polygon
        if (shape) {
          if (shape.polygon) {
            renderPolygon();
          } else if (shape.circle) {
            renderCircle(shape);
          }
  
          $(selectCellSelector).css('display', '');
  
          $('#generatePDF').show();
          $('#saveIdWinner').show();
          $('#generatePDF2').show();
        }
  
        AAAPGMAP.multipoint = new esri.geometry.Multipoint(
          AAAPGMAP.map.spatialReference
        );
  
        // If there is a polygon, set it.
        AAAPGMAP.map.graphics.graphics.forEach(function(a, i) {
          if (a.geometry.type == 'polygon') {
            polygonOnMap = a.geometry;
          }
        });
  
        var globalrank = 1;
  
  /*
        // Sort by placing the cheapest props at the end.
        var lowest = [];
        var other = [];
        $.each(props.formData, function(index){
          this.cheapest ? lowest.unshift(this) : other.push(this);
        });
        props.formData = other.concat(lowest);
  */
      $.each(props.formData, function(index) {
          this.inBounds = false;
          var point = new Point(this.Lng, this.Lat);
          // Create pointer graphic for this property.
          var graphic = new Graphic(
            point,
            new SimpleMarkerSymbol(
              SimpleMarkerSymbol.STYLE_CIRCLE,
              15,
              new SimpleLineSymbol(
                SimpleLineSymbol.STYLE_SOLID,
                new Color([0,0,0]),
                1
              ),
              new Color([0,0,0])
            )
          );
          if (
            graphic.geometry.x &&
            graphic.geometry.x !== 0 &&
            graphic.geometry.y &&
            graphic.geometry.y !== 0 &&
            polygonOnMap.contains(graphic.geometry)
            )
                  {
                     this.inBounds = true;
                  this.rank = globalrank++;
                  }
  
        });
              
      // Find the cheapest PV value.
        var cheapest = null;
        $.each(props.formData, function(index) {
          if ((cheapest === null || cheapest.pvCosts > this.pvCosts) && this.inBounds == true) {
            cheapest = this;
          }
        });
        
        var lowest = [];
        var other = [];
        $.each(props.formData, function(index){
          this == cheapest ? lowest.unshift(this) : other.push(this);
        });
        props.formData = other.concat(lowest);
        
        //var sorted = props.formData;
        //sorted.sort(function(a,b){ (a==cheapest?0:1)-(b==cheapest?0:1) });
        
        // Create markers for properties.
        //console.log('JK props ' + JSON.stringify(props.formData))
        $.each(props.formData, function(index) {
          //this.inBounds = false;
            
          var point = new Point(this.Lng, this.Lat);
          //console.log('JK each point ' + JSON.stringify(point));
          //no matter the rank, the point shows as the same red color. Left the previous logic in here
          var bg = this == cheapest ? [128, 0, 0]: [128, 0, 0];
          var line = this == cheapest ? [178, 34, 34]: [178, 34, 34];
  
          // Create pointer graphic for this property.
          var graphic = new Graphic(
            point,
            new SimpleMarkerSymbol(
              SimpleMarkerSymbol.STYLE_CIRCLE,
              15,
              new SimpleLineSymbol(
                SimpleLineSymbol.STYLE_SOLID,
                new Color(line),
                1
              ),
              new Color(bg)
            )
          );
  
          // this is the property data.
          graphic.setAttributes({ fd: this });
  
          // If there is a polygon on the map and the point is inside
          // the polygon, add the point. If no polygon, always add point.
          //console.log('JK polygonOnMap ' + JSON.stringify(polygonOnMap));
          if (!polygonOnMap || polygonOnMap) {// && polygonOnMap.contains(graphic.geometry)) { //JK took this out so that points not within the polygon still appear on the map
            AAAPGMAP.map.graphics.add(graphic);
            AAAPGMAP.multipoint.addPoint(point);
          }
          //console.log('JK polygon is on the map and point is inside OR no polygon');
          //console.log(AAAPGMAP);
        });
  
        // Determine if the point is inside the polygon.  If so,
        // the inBounds attribute will show or hide the address
        // table record.
        AAAPGMAP.map.graphics.graphics.forEach(function(a, i) {
          if (
            a.geometry.x &&
            a.geometry.x !== 0 &&
            a.geometry.y &&
            a.geometry.y !== 0 &&
            polygonOnMap.contains(AAAPGMAP.map.graphics.graphics[i].geometry)
          ) {
            $.each(props.formData, function(index) {
              if (this.Lng == a.geometry.x && this.Lat == a.geometry.y) {
                //this.inBounds = true;
              //  this.rank = globalrank++;
              }
            });
          }
        });
  
        // Show or hide the table records based on if they are inside the polygon.
        $.each(props.formData, function() {
          var sel = '#selectCell_' + this.spaceId + '_' + this.offerId;
  
          $(sel).css('display', this.inBounds ? '' : 'none');
          $(sel)
            .closest('tr')
            .css('display', this.inBounds ? '' : 'none');
        });
  
        // EVENT: Mouse-over
        AAAPGMAP.map.graphics.on('click', function(e) {
          if (e.graphic.geometry.type == 'point') {
  
            var fd = e.graphic.attributes.fd;
            console.log('fd', fd);
            var flags = function() {
              var paths = [];
              /**
              switch (true) { 
                case if(fd.isAwarded):
                  paths.push(SF.Flags.Awarded);  
                case if(fd.isBuildingProblem:
                  paths.push(SF.Flags.Problems);
                case if(fd.isEnergyStar):
                  paths.push(SF.Flags.EnergyStar);
                case if(fd.isHUBZONEArea):
                  paths.push(SF.Flags.HubZone);
                case if(fd.isHistoricProperty):
                  paths.push(SF.Flags.Historic); 
                case if(fd.isMetro):
                  paths.push(SF.Flags.Metro);
                default:
              }
              **/
              
              if(fd.isAwarded)
                  paths.push(SF.Flags.Awarded); 
               if(fd.isBuildingProblem)
                  paths.push(SF.Flags.Problems);
               if(fd.isEnergyStar)
                  paths.push(SF.Flags.EnergyStar);
               if(fd.isHUBZONEArea)
                  paths.push(SF.Flags.HubZone);
               if(fd.isHistoricProperty)
                  paths.push(SF.Flags.Historic); 
               if(fd.isMetro)
                  paths.push(SF.Flags.Metro);
              
              // This one requires strict equality for some reason
              // I'm not going to spend time looking into at this moments.
              if (fd.isSelected === true) {
                paths.push(SF.Flags.Selected);
              }
  
              for (var i = 0; i < paths.length; i++) {
                paths[i] =
                  '<img src="' + paths[i] + '" height="20px" width="20px">';
              }
  
              return paths.join('');
            };
  
            // At the time of writing, fd.state does not exist.  So we're 
            // conditionally adding so that when the field becomes available,
            // it will be displayed.  After that, this conditional can be
            // removed.
            //removed the 'Rank' Indicator
            var content =
              '<table class="marker-table">' +
              '<tr><th>Building Name:</th><td>' +
              fd.buildingName +
              '</td></tr>' +
              '<tr><th>Address:</th><td>' +
              fd.street + ', ' + fd.city + (fd.state ? ', ' + fd.state : '') +
              '</td></tr>' +
              '<tr><th>Coordinates:</th><td>' +
              fd.Lat +
              ', ' +
              fd.Lng +
              '</td></tr>' +
              '<tr><th>Flags:</th><td>' +
              flags() +
              '</td></tr>' +
              '</table>';
  
            AAAPGMAP.map.infoWindow.setTitle(fd.street);
            AAAPGMAP.map.infoWindow.setContent(content);
            AAAPGMAP.map.infoWindow.show(e.graphic.geometry);
          }
        });
  
        // EVENT: Mouse-out
        AAAPGMAP.map.on('click', function(e) {
          if (e.graphic.geometry.type !== 'point') {
            // AAAPGMAP.map.infoWindow.hide();
          }
        });
        
      });
    });
  }
  
  AAAPGMAP.setExtent = function() {
    var points = AAAPGMAP.multipoint.points;
    //console.log('JK points ' + JSON.stringify(points));
    var zoom = AAAPGMAP.map.getZoom();
  
    zoom = zoom < 13 ? 13 : zoom;
  
    var geolocationToCartesian = function(lon, lat) {
      var cartesian = AAAPGMAP.webMercatorUtils.lngLatToXY(lon, lat);
      return { x: cartesian[0], y: cartesian[1] };
    };
  
    //console.log('JK points.length ' + points.length);

    if (points.length === 0) {
      AAAPGMAP.map.setZoom(zoom);
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
  };
  