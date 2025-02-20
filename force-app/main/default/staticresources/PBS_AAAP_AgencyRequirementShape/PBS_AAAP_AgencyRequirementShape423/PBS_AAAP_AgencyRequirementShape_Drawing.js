var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;
    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ?
                true :
                decodeURIComponent(sParameterName[1]);
        }
    }
};

var isCopy = getUrlParameter('copy');

/**
 * Drawing class declaration.
 */
function Drawing() {}

Drawing.prototype.showDrawInstr = function() {

  console.log('Selected drawing instructions');
  const userContext = currentUserContext;
  console.log('VF Page Theme: ' + userContext);

  if (window.innerWidth > 1200) {
    console.log('Window width: ' + window.innerWidth + ' so displaying instructions top...');
    $('#draw_instr_div').css('display', 'block');
    $('#draw_instr_div_mobile').css('display', 'none');
    $('#edit_instr_div').css('display', 'none');
    $('#edit_instr_div_mobile').css('display', 'none');
    $('#fav_instr_div').css('display', 'none');
    $('#fav_instr_div_mobile').css('display', 'none');
    $('#close_instr_div').css('display', 'block');
    $('#close_instr_div_mobile').css('display', 'none');
  } else {
    console.log('Window width is ' + window.innerWidth + ' so displaying instructions below...');
    $('#draw_instr_div').css('display', 'none');
    $('#draw_instr_div_mobile').css('display', 'block');
    $('#edit_instr_div').css('display', 'none');
    $('#edit_instr_div_mobile').css('display', 'none');
    $('#fav_instr_div').css('display', 'none');
    $('#fav_instr_div_mobile').css('display', 'none');
    $('#close_instr_div').css('display', 'none');
    $('#close_instr_div_mobile').css('display', 'block');
    if (userContext === 'Theme2' || userContext === 'Theme3') {
      //no need to adjust close button location for Classic
    } else {
      $('#close_instr_div_mobile').css('margin-top', '-38px');
    }
  }
};

Drawing.prototype.showEditInstr = function() {
   
  console.log('Selected editing instructions');
  const userContext = currentUserContext;
  console.log('VF Page Theme: ' + userContext);

  if (window.innerWidth > 1200) {
    console.log('Window width: ' + window.innerWidth + ' so displaying instructions top...');
    $('#draw_instr_div').css('display', 'none');
    $('#draw_instr_div_mobile').css('display', 'none');
    $('#edit_instr_div').css('display', 'block');
    $('#edit_instr_div_mobile').css('display', 'none');
    $('#fav_instr_div').css('display', 'none');
    $('#fav_instr_div_mobile').css('display', 'none');
    $('#close_instr_div').css('display', 'block');
    $('#close_instr_div_mobile').css('display', 'none');
  } else {
    console.log('Window width is ' + window.innerWidth + ' so displaying instructions below...');
    $('#draw_instr_div').css('display', 'none');
    $('#draw_instr_div_mobile').css('display', 'none');
    $('#edit_instr_div').css('display', 'none');
    $('#edit_instr_div_mobile').css('display', 'block');
    $('#fav_instr_div').css('display', 'none');
    $('#fav_instr_div_mobile').css('display', 'none');
    $('#close_instr_div').css('display', 'none');
    $('#close_instr_div_mobile').css('display', 'block');
    if (userContext === 'Theme2' || userContext === 'Theme3') {
      //no need to adjust close button location for Classic
    } else {
      $('#close_instr_div_mobile').css('margin-top', '-38px');
    }
  }

};
        
Drawing.prototype.showFavInstr = function() {
   
  console.log('Selected drawing instructions');
  const userContext = currentUserContext;
  console.log('VF Page Theme: ' + userContext);

  if (window.innerWidth > 1200) {
    console.log('Window width: ' + window.innerWidth + ' so displaying instructions top...');
    $('#draw_instr_div').css('display', 'none');
    $('#draw_instr_div_mobile').css('display', 'none');
    $('#edit_instr_div').css('display', 'none');
    $('#edit_instr_div_mobile').css('display', 'none');
    $('#fav_instr_div').css('display', 'block');
    $('#fav_instr_div_mobile').css('display', 'none');
    $('#close_instr_div').css('display', 'block');
    $('#close_instr_div_mobile').css('display', 'none');
  } else {
    console.log('Window width is ' + window.innerWidth + ' so displaying instructions below...');
    $('#draw_instr_div').css('display', 'none');
    $('#draw_instr_div_mobile').css('display', 'none');
    $('#edit_instr_div').css('display', 'none');
    $('#edit_instr_div_mobile').css('display', 'none');
    $('#fav_instr_div').css('display', 'none');
    $('#fav_instr_div_mobile').css('display', 'block');
    $('#close_instr_div').css('display', 'none');
    $('#close_instr_div_mobile').css('display', 'block');
    if (userContext === 'Theme2' || userContext === 'Theme3') {
      //no need to adjust close button location for Classic
    } else {
      $('#close_instr_div_mobile').css('margin-top', '-38px');
    }
  }

};

Drawing.prototype.closeInstrDiv = function() {
   
  console.log('Clicked the close instructions button');
  $('#draw_instr_div').css('display', 'none');
  $('#draw_instr_div_mobile').css('display', 'none');
  $('#edit_instr_div').css('display', 'none');
  $('#edit_instr_div_mobile').css('display', 'none');
  $('#fav_instr_div').css('display', 'none');
  $('#fav_instr_div_mobile').css('display', 'none');
  $('#close_instr_div').css('display', 'none');
  $('#close_instr_div_mobile').css('display', 'none');

};


Drawing.prototype.toggleFav = function() {
    if ($('[id*=val_usr_del_area_fav]').is(':checked')) {
        console.log('drawing.toggleFav function: TRUE');
        SF.fPoly = 'true';
    } else {
        console.log('drawing.toggleFav function: FALSE');
        SF.fPoly = 'false';
    }
};

/**
 * Edit method.
 */
Drawing.prototype.edit = function() {
    require([
        'esri/widgets/Sketch/SketchViewModel',
        'esri/layers/GraphicsLayer'
    ], function(SketchViewModel, GraphicsLayer) {

        console.log('Starting drawing.edit()...');

        $('#polyTd').css('font-weight', 'normal');
        $('#polyTd').css('background-color', '#ffffff');
        //$('#circleTd').css('background-color', '#ffffff');
        $('#editTd').css('font-weight', 'bold');
        $('#editTd').css('background-color', 'silver');
        $('#undoTd').css('display', 'none');

        AAAPGMAP.mode = 'edit shape';

        AAAPGMAP.mapview.graphics.removeAll(); 
        AAAPGMAP.mapview.map.layers.removeAll();
        console.log('Removed all graphics from the map.');

        //console.log('Creating new GraphicsLayer for AAAPGMAP.graphic: ' + JSON.stringify(AAAPGMAP.graphic));
        let graphicsLayer = new GraphicsLayer({
            graphics: [AAAPGMAP.graphic]
        });



/*
// set the mapview surface cursor to default
const mapContainer = document.getElementById('map_canvas');
if (mapContainer) {
    for (let i = 0; i < mapContainer.childNodes.length; i++) {
        const rootElement = mapContainer.childNodes[i] as Element;
        if ((mapContainer.childNodes[i] as Element).classList.contains('esri-view-root')) {
            for (let j = 0; j < rootElement.childNodes.length; j++) {
                const viewSurface = rootElement.childNodes[j] as Element;
                if (viewSurface.classList.contains('esri-view-surface')) {
                    (viewSurface as HTMLElement).style.cursor = 'default';
                }
            }
        }
    }
}

*/


        console.log('Adding GraphicsLayer to AAAPGMAP.mapview.map...');
        AAAPGMAP.mapview.map.add(graphicsLayer);

        if (SF.Shape) {
            console.log('Removing the underling graphic from AAAPGMAP.mapview.graphics collection since coming in under Edit Mode...');
            AAAPGMAP.mapview.graphics.removeAll();
        }

        const sketch = new SketchViewModel({
            view: AAAPGMAP.mapview,
            layer: graphicsLayer,
            creationMode: 'update',
            defaultUpdateOptions: {
                tool: 'reshape',
                enableRotation: false,
                enableScaling: false
            }
        });

        var operation, oldGraphic;

        //if (AAAPGMAP.graphic.attributes.shape == 'POLYGON') {
        //    console.log('shape is polygon');

            sketch.on("update", onGraphicUpdate);

            function onGraphicUpdate(event) {
                // get the graphic as it is being updated
                const graphic = event.graphics[0];
                AAAPGMAP.graphic = event.graphics[0];
                // check if the update event's the toolEventInfo.type is move-stop or reshape-stop
                // user finished moving or reshaping the graphic, call complete method.
                // This changes update event state to complete.
                if (event.state === "complete") {
                    //alert('Stopped updating new shape');
                }
            }

        //} 
    }); // end require
};

/**
 * Undo edit method.
 */
Drawing.prototype.undo = function() {
    AAAPGMAP.undoEdit.undo();
    this.edit();
};

/**
 * Save method.
 */
Drawing.prototype.save = function() {

    console.log('Starting drawing.save() function...');

    var separator = '*';

    const graphics = AAAPGMAP.mapview.graphics;
    var poly;
    var found = false;
    for (const graphic of graphics) {
        poly = graphic.geometry;
        found = true;
    }
    if (found) {
        console.log('Graphic geometry to save: ' + JSON.stringify(poly));
    } else {
        poly = AAAPGMAP.graphic.geometry;
        console.log('Graphicslayer geometry to save: ' + JSON.stringify(poly));
    }

    var outer = [];
    var inner = [];
    var vals = {};

    for (i = 0; i < poly.rings[0].length - 1; i++) {
        var polyPt = poly.getPoint(0, i);

        // build the string with separators for easier splitting
        vals =
            i +
            separator +
            //polyPt.getLatitude() +
            polyPt.latitude +
            separator +
            //polyPt.getLongitude();
            polyPt.longitude;

        var innerLength = inner.push(vals);
        var outerLength = outer.push(inner);

        inner = [];
        vals = {};
    }

    var shapeName;
    if (AAAPGMAP.pname) {
        shapeName = $('[id$="val_usr_del_area_name"]').val();
    } else {
        shapeName = '';
    }

    console.log('About to call PBS_AAAP_AgencyRequirementShape.savePoly()...');

    console.log('SF.agncyID: ' + SF.agncyID);
    console.log('SF.polyID: ' + SF.polyID);
    console.log('AAAPGMAP.pname: ' + $(AAAPGMAP.pname).val());
    console.log('outer: ' + outer);
    console.log('circle: ' + '0.0');
    console.log('SF.fPoly: ' + SF.fPoly);
    console.log('isCopy: ' + isCopy);

    PBS_AAAP_AgencyRequirementShape.savePoly(
        SF.agncyID,
        SF.polyID,
        'polygon',
        $(AAAPGMAP.pname).val(),
        outer,
        '0.0',
        SF.fPoly,
        isCopy,
        function(result, event) {
            if (result[0] === 'success') {
                PBS_AAAP_AgencyRequirementShape.backToAgncyReq(
                    SF.agncyID,
                    SF.polyID,
                    $(AAAPGMAP.pname).val(),
                    function(result, event) {
                        window.location.href = result;
                    }
                );
            }
            if (result[0] === 'failed') {
                alert(result[1]);
            }
        }
    );
};

/**
 * Reset method.
 */
Drawing.prototype.reset = function() {

    var shape = new Shape();

    for (const graphic of AAAPGMAP.mapview.graphics) {
        AAAPGMAP.mapview.graphics.remove(graphic);
    }

    if (AAAPGMAP.shapeData) {
        if (AAAPGMAP.shapeData.polygon) {
            console.log('About to call shape.polygon.render()...');
            shape.polygon.renderNoExpand();
            console.log('About to call drawing.edit()...');
            drawing.edit();
        }
        $('#editTd').css('background-color', 'silver');
        $('#editTd').css('font-weight', 'bold');
        $('#undoTd').css('display', 'none');
    } //end if
};

/**
 * Clear method.
 */
Drawing.prototype.clear = function() {
    $('#undoTd').css('display', 'none');
    $('#editTd').css('font-weight', 'normal');
    $('#editTd').css('background-color', '#ffffff');
    $('#polyTd').css('font-weight', 'normal');
    $('#polyTd').css('background-color', '#ffffff');
    AAAPGMAP.mapview.graphics.removeAll();
    AAAPGMAP.mapview.map.layers.removeAll();
};

