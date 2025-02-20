function renderMap() {
	require([
		'esri/Map',
		'esri/views/MapView',
		'esri/geometry/Point',
		'esri/geometry/Multipoint',
		'esri/geometry/support/webMercatorUtils',
		'esri/symbols/SimpleMarkerSymbol',
		'esri/symbols/SimpleLineSymbol',
		'esri/Graphic',
		'esri/layers/GraphicsLayer',
		'esri/Color',
                'esri/PopupTemplate',
		'dojo/domReady!'
	], function(
		Map,
		MapView,
		Point,
		Multipoint,
		webMercatorUtils,
		SimpleMarkerSymbol,
		SimpleLineSymbol,
		Graphic,
		GraphicsLayer,
		Color,
                PopupTemplate
	) {
		AAAPGMAP.webMercatorUtils = webMercatorUtils;

		var container = $('[id$="map_canvas"]');
		$(container).show();
                $(container).css('height', '500px');
		$(container).css('width', '100%');

		// Create new map and view instance.
		console.log('PBS_AAAP_IdentifyWinnerSearch_Map.js renderMap() creating AAAPGMAP.map...');
		AAAPGMAP.map = new Map({
			basemap: 'topo-vector',
			layers: [new GraphicsLayer]
		});

		console.log('PBS_AAAP_IdentifyWinnerSearch_Map.js renderMap() creating AAAPGMAP.mapview...');
		AAAPGMAP.mapview = new MapView({
			map: AAAPGMAP.map,
			container: $('[id$="map_canvas"]').attr('id'),
			zoom: 8,
			center: [-84.409939, 33.7528113]
		})

		//AAAPGMAP.map.on('load', function() {
		var polygonOnMap = false;
		if (shape && shape.polygon) {
			console.log('PBS_AAAP_IdentifyWinnerSearch_Map.js renderMap() calling renderPolygon()...');
			renderPolygon();
			$(selectCellSelector).css('display', '');
			$('#generatePDF').show();
			$('#saveIdWinner').show();
			$('#generatePDF2').show();
		}

		AAAPGMAP.multipoint = new Multipoint(
			AAAPGMAP.mapview.spatialReference
		);

		// If there is a polygon, set it.
		//AAAPGMAP.map.graphics.graphics.forEach(function(a, i) {
		console.log('PBS_AAAP_IdentifyWinnerSearch_Map.js renderMap() about to loop through AAAPGMAP.mapview.graphics to see if there is a polygon on the map...');
		console.log('AAAPGMAP.mapview.graphics: ' + JSON.stringify(AAAPGMAP.mapview.graphics));
		AAAPGMAP.mapview.graphics.forEach(function(a, i) {
			if (a.geometry.type == 'polygon') {
				polygonOnMap = a.geometry;
			}
		});
		console.log('PolygonOnMap: ' + JSON.stringify(polygonOnMap));

		var globalrank = 1;

		console.log('PBS_AAAP_IdentifyWinnerSearch_Map.js renderMap() about to loop through props.formData to see if the property location(s) is/are within the polygon shape...');
		$.each(props.formData, function(index) {
			this.inBounds = false;
			var point = new Point(this.Lng, this.Lat);
			// Create pointer graphic for this property in order to verify it is within the polygon on the map
			var graphic = new Graphic(
				point,
				new SimpleMarkerSymbol(
					SimpleMarkerSymbol.STYLE_CIRCLE,
					15,
					new SimpleLineSymbol(
						SimpleLineSymbol.STYLE_SOLID,
						new Color([0, 0, 0]),
						1
					),
					new Color([25, 25, 25])
				)
			);
			if (
				graphic.geometry.x &&
				graphic.geometry.x !== 0 &&
				graphic.geometry.y &&
				graphic.geometry.y !== 0 &&
				polygonOnMap.contains(graphic.geometry)
			) {
				this.inBounds = true;
				this.rank = globalrank++;
				console.log('Property was within the polygon ', this);
			} else {
				console.log('Property was not within the polygon ', this);
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
		$.each(props.formData, function(index) {
			this == cheapest ? lowest.unshift(this) : other.push(this);
		});
		props.formData = other.concat(lowest);

		//var sorted = props.formData;
		//sorted.sort(function(a,b){ (a==cheapest?0:1)-(b==cheapest?0:1) });

		// Create markers for properties.
		console.log('About to loop through properties to create markers. props.formData: ' + JSON.stringify(props.formData));
		$.each(props.formData, function(index) {
			//this.inBounds = false;

			var point = new Point(this.Lng, this.Lat);
			//no matter the rank, the point shows as the same red color. Left the previous logic in here
			//var bg = this == cheapest ? [128, 0, 0] : [128, 0, 0];
			//var line = this == cheapest ? [178, 34, 34] : [178, 34, 34];
			console.log('Next prop to add point graphic: ' + JSON.stringify(this));
		        var simpleMarkerSymbol = {
		           type: "simple-marker",
		           style: "circle",
		           color: [255, 0, 0, 255],//red
		           size: 12,
		           outline: {  
		              color: [0, 0, 0, 255], // black
		              width: 1
		           }
		        };
			
			console.log('******About to push flags images onto the point popupTemplate...');
			var paths = [];
			if (this.isAwarded === true) {
				console.log('Pushing "isAwarded" flag: ', SF.Flags.Awarded);
				paths.push(SF.Flags.Awarded);
                        };
			if (this.isBuildingProblem === true) {
				console.log('Pushing "isBuildingProblem" flag: ', SF.Flags.Problems);
				paths.push(SF.Flags.Problems);
                        };
			if (this.isEnergyStar === true) {
				console.log('Pushing "isEnergyStar" flag: ', SF.Flags.EnergyStar);
				paths.push(SF.Flags.EnergyStar);
                        };
			if (this.isHUBZONEArea === true) {
				console.log('Pushing "isHUBZONEArea" flag: ', SF.Flags.HubZone);
				paths.push(SF.Flags.HubZone);
                        };
			if (this.isHistoricProperty === true) {
				console.log('Pushing "isHistoricProperty" flag: ', SF.Flags.Historic);
				paths.push(SF.Flags.Historic);
                        };
			if (this.isMetro === true) {
				console.log('Pushing "isMetro" flag: ', SF.Flags.Metro);
				paths.push(SF.Flags.Metro);
                        };
			if (this.isSelected === true) {
				console.log('Pushing "isSelected" flag: ', SF.Flags.Selected);
				paths.push(SF.Flags.Selected);
			};
			console.log('About to loop through all the pushed flags to build Img tags...');
			for (var i = 0; i < paths.length; i++) {
				console.log('Next flag source being replaced with entire img tag: ', paths[i]);
				paths[i] = '<img src="' + paths[i] + '" height="20px" width="20px">';
				console.log('After replacement: ', paths[i]);
			};

			var flags = paths.join('');
			console.log('flags variable after join: ', flags);

			var content = 	'<table class="marker-table">' +
					'<tr><th>Building Name:</th><td>' +
					this.buildingName +
					'</td></tr>' +
					'<tr><th>Address:</th><td>' +
					this.street + ', ' + this.city + (this.state ? ', ' + this.state : '') +
					'</td></tr>' +
					'<tr><th>Coordinates:</th><td>' +
					this.Lat +
					', ' +
					this.Lng +
					'</td></tr>' +
					'<tr><th>Flags:</th><td>' +
					flags +
					'</td></tr>' +
					'</table>';
			console.log('Content before adding to PopupTemplate: ', content);

/*			let popupTemplate = new PopupTemplate({
				title: this.street,
				content: content
			});
*/
			let popupTemplate = new PopupTemplate({
				title: this.street,
				content: function() {
					const div = document.createElement("div");
					div.innerHTML = content;
					return div;
				}
			});

/*			let popupTemplate = new PopupTemplate({
				title: this.street,
				content: [{
        				type: "text", // TextContentElement
        				text: content
        			},
        			{
        				type: "media", // MediaContentElement
        				mediaInfos: [{
        						title: "<b>Awarded:</b>",
        						type: "image",
        						caption: "",
        						value: {
        							sourceURL: "/resource/1349104065000/Offer_Awarded"
        						}
        					},
        					{
        						title: "<b>Energy Star:</b>",
        						type: "image",
        						caption: "",
        						value: {
        							sourceURL: "/resource/1349104065000/Offer_EnergyStar"
        						}
        					}
        				]
        			}]
			});
*/
		        var graphic = new Graphic({
		           geometry: point,
		           symbol: simpleMarkerSymbol,
			   attributes: { "fd": this },
		           popupTemplate: popupTemplate
		        });

			// If there is a polygon on the map and the point is inside
			// the polygon, add the point. If no polygon, always add point.
			console.log('Adding point graphic to map and point to multiPoint ' + JSON.stringify(graphic));
			if (!polygonOnMap || polygonOnMap) { // && polygonOnMap.contains(graphic.geometry)) { //JK took this out so that points not within the polygon still appear on the map
				//AAAPGMAP.map.graphics.add(graphic);
				AAAPGMAP.mapview.graphics.add(graphic);
				AAAPGMAP.multipoint.addPoint(point);
			}
			//console.log('AAAPGMAP: ', AAAPGMAP);
		});

/*		// Determine if the point is inside the polygon.  If so,
		// the inBounds attribute will show or hide the address
		// table record.
		//AAAPGMAP.map.graphics.graphics.forEach(function(a, i) {
		AAAPGMAP.mapview.graphics.forEach(function(a, i) {
			if (
				a.geometry.x &&
				a.geometry.x !== 0 &&
				a.geometry.y &&
				a.geometry.y !== 0 &&
				//polygonOnMap.contains(AAAPGMAP.map.graphics.graphics[i].geometry)
                                polygonOnMap.contains(AAAPGMAP.mapview.graphics.items[i].geometry)
			) {
				$.each(props.formData, function(index) {
					if (this.Lng == a.geometry.x && this.Lat == a.geometry.y) {
						//this.inBounds = true;
						//  this.rank = globalrank++;
					}
				});
			}
		});
*/
		// Show or hide the table records based on if they are inside the polygon.
		$.each(props.formData, function() {
			var sel = '#selectCell_' + this.spaceId + '_' + this.offerId;

			$(sel).css('display', this.inBounds ? '' : 'none');
			$(sel)
				.closest('tr')
				.css('display', this.inBounds ? '' : 'none');
		});

		//AAAPGMAP.map.graphics.on('click', function(e) {
		AAAPGMAP.mapview.graphics.on('click', function(e) {
			if (e.graphic.geometry.type == 'point') {

				var fd = e.graphic.attributes.fd;
				console.log('fd: ', fd);

				var flags = function() {
					var paths = [];

					if (fd.isAwarded)
						paths.push(SF.Flags.Awarded);
					if (fd.isBuildingProblem)
						paths.push(SF.Flags.Problems);
					if (fd.isEnergyStar)
						paths.push(SF.Flags.EnergyStar);
					if (fd.isHUBZONEArea)
						paths.push(SF.Flags.HubZone);
					if (fd.isHistoricProperty)
						paths.push(SF.Flags.Historic);
					if (fd.isMetro)
						paths.push(SF.Flags.Metro);
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

				//AAAPGMAP.map.infoWindow.setTitle(fd.street);
				//AAAPGMAP.map.infoWindow.setContent(content);
				//AAAPGMAP.map.infoWindow.show(e.graphic.geometry);
			}
		});

		// EVENT: Mouse-out
		//AAAPGMAP.map.on('click', function(e) {
		//if (e.graphic.geometry.type !== 'point') {
		// AAAPGMAP.map.infoWindow.hide();
		//}
		//});

		//});
	});
}

AAAPGMAP.setExtent = function() {
	var points = AAAPGMAP.multipoint.points;
	//console.log('JK points ' + JSON.stringify(points));
	var zoom = AAAPGMAP.map.getZoom();

	zoom = zoom < 13 ? 13 : zoom;

	var geolocationToCartesian = function(lon, lat) {
		var cartesian = AAAPGMAP.webMercatorUtils.lngLatToXY(lon, lat);
		return {
			x: cartesian[0],
			y: cartesian[1]
		};
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