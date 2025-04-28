/*ArcGIS JS API v4.19 Offer Building Interface. Contains business logic for loading the map, table, and form*/
/*refactored June 2021 by Julia Kantarovsky*/

//Interface Offer Building Section 1: Formerly PBS_AAAP_OfferBuilding_419.js

console.log('Todd testing offer building ArcGIS_Interface JS starting up...');

let AAAP = {};
AAAP.form = {
    container: null,
    location: {
        street: 'default street',
        city: 'default city',
        state: 'default state',
        zip: 'default zip',
        county: 'default county',
        lat: 'default lat',
        Lng: 'default Lng'
    },
    rlp: ''
};
AAAP.map = {
    container: null,
    service: null
};
AAAP.table = {
    container: null
}

//Form Init
AAAP.form.initialize = function (initialLoad) {
    //Initialize the form.
    if (initialLoad) {
        // Set form
        this.container = $('[id$="newOffer"]');
        // Disable autocomplete on form level.
        this.container.attr('autoComplete', 'off');//this is not working
        this.initSearchButtons();
        this.initSearchLocation();


        // added by syam to fix the calendar issue with the uniform style
        // class to the select components. so we omitted calendar select
        // fields from applying uniform style class.
        $('select').each(function () {
            var id = $(this).prop('id');

            if (id != 'calMonthPicker' && id != 'calYearPicker') {
                $(this).uniform();
            }
        });

        $(
            [
                'input:submit',
                'input:checkbox',
                'input:text',
                'input:password',
                'input:button',
                'button'
            ].join(',')
        ).uniform(); 

        // Disable autocomplete on all form fields.
        $('input[id$="bname"]').attr('autoComplete', 'new-password');

        // If any of these fields change, hide the
        // other building data fields.
        $(
            [
                'input[id$="baddress"]',
                'input[id$="bstreet"]',
                'input[id$="bcity"]',
                'input[id$="bstate"]',
                'input[id$="bzip"]',
                'input[id$="bcounty"]'
            ].join(',')
        )
            .attr('autoComplete', 'new-password')
            .each(function (input) {
                $(this).on('keyup', function () {
                    $('[id$="other_bldg_data"]').hide();
                });
            });


        $('select[id$="chooseRLP"]').on(
            'change',
            function () {
                this.rlpChanged();
            }.bind(this)
        );


        $('#accept-address').on('click', function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file accept-address onClick starting...');

            AAAP.map.container.hide();
            $('[id$="other_bldg_data"]').show();
            $(this).hide();
            $('#show-map').show();
        });

        $('#show-map').on('click', function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file show-map() onClick starting...');

    //when user clicks show map button
    AAAP.map.container.show();
            $(this).hide();
            $('#accept-address').show();

            var address = $('.suggestive-search--input.address').val();//here is where the user input address get sets to the var address

            if (address.length > 0) {
                AAAP.form.clearMapMarkers();

                AAAP.map
                    .getService()
                    .moveMarker($('[id$="baddress"]').val(), { 
                        street: $('[id$="bstreet"]').val(),
                        city: $('[id$="bcity"]').val(),
                        state: $('[id$="bstate"]').val(),
                        county: $('[id$="bcounty"]').val(),
                        zip: $('[id$="bzip"]').val(),
                        lon: $('[id$="bYCood"]').val(),
                        lat: $('[id$="bXCood"]').val()
                    })
                    .then(function (marker) {
                        AAAP.table.initialize(marker.location);
                        AAAP.map.container.show();
                    })
                    .catch(function (error) {
                        console.error(error);
                    });
            }
        });

        $('#show-latlon').on('click', function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file show-latlon() onClick starting...');

            $('#coordinate-container').show();
            $(this)
                .parent()
                .hide();
        });

        $('#cancel-coordinates').on('click', function () {
            $('#coordinate-container').hide();
            $('#show-latlon').parent().show();
        });
    }

    if ($('[id$="baddress"]').val().length > 0) {
        $('#show-map').show();
    }

    // Remove building type if not set.
    var buildingtype = $('[id$="buildingType"]')[0];
    if (buildingtype && !buildingtype[0].val()) {
        buildingtype.remove(0);
    }

    // Remove building code if not set.
    var buildingcode = $('[id$="buildingCode"]')[0];
    if (buildingcode && !buildingcode[0].val()) {
        buildingcode.remove(0);
    }

    // Remove building code year if not set.
    var buildingcodeYear = $('[id$="buildingCodeYear"]')[0];
    if (buildingcodeYear && !buildingcodeYear[0].val()) {
        buildingcodeYear.remove(0);
    }

    // Get newly selected RLP.
    var rlp = $('select[id$="chooseRLP"]')
        .children(':selected')
        .text();

    // rlp is set.
    if (rlp.length > 0 && rlp !== 'Select RLP') {
        if (this.rlp.length > 0) {
            // Clear error if there is one.
            $('[id$="msgErr"]').text('');

            // rlp has changed and message is not set.
            if (this.rlp !== rlp && $('[id$="message"]').text().length === 0) {
                // Set RLP.
                this.rlp = rlp;
                // Save form.
                $('[id$="btnSaveForm"]').click();
            }
        }

        //here it shows the nonRLPinput section, including address input
        $('#nonRlpInputSection, [id$="bld_addr_fields"]').show();
        if (initialLoad) {
            $('[id$="other_bldg_data"]').show();
        } else {
            $('[id$="other_bldg_data"]').hide();
        }
    }

    // rlp is not set.
    else {
        $(
            '#nonRlpInputSection, [id$="bld_addr_fields"], [id$="other_bldg_data"]'
        ).hide();
        $('[id$="msgErr02"]').text('');
        $('[id$="msgErr"]').text(
            'Select RLP and then click Save Form at the bottom of the page before proceeding.'
        );
    }
};

/*class AAAP {
    constructor() {
        //Defaults form and map
        form = {
            container: null,
            location: {
                street: 'default street',
                city: 'default city',
                state: 'default state',
                zip: 'default zip',
                county: 'default county',
                lat: 'default lat',
                Lng: 'default Lng'
            },
            rlp: ''
        };

        map = {
            container: null,
            service: null
        };
    }
}*/


//Interface Offer Building Section 2: Formerly PBS_AAAP_OfferBuilding_Form_419.js

AAAP.form.clearMapMarkers = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file clearMapMarkers() starting...');

    var markers = Object.keys(AAAP.map.getService().markers);
    //if there is a marker, then remove them before adding a new marker. 'i' in marker[i] is the randomly generated ID
    for (var i = 0; i < markers.length; i++) {
        AAAP.map
            .getService()
            .removeMarker(markers[i]);//removes the marker according to the generated id
    }
};

//When a user clicks Submit button, calls this function
AAAP.form.initSearchButtons = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file initSearchButtons() starting...');

    $('#submit-address').on('click', function () {
        var address = $('.suggestive-search--input.address').val();

        //Thursday added this back in
        //AAAP.form.clearMapMarkers();//removed this line because clearMapMarkers calls removeMarker, which is commented out

        AAAP.map
            .getService()
            .search({ singleLineAddress: address })
            .then(function (marker) {
                AAAP.table.initialize(marker.location);
                AAAP.map.container.show();
            })
            .catch(function (error) {
                console.error(error);//error here if nothing is input into address box. Shouldn't there be a message?
            });
    });

    $('#submit-coordinates').on('click', function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file submit-coordinates() onClick starting...');

        var lat = $('.suggestive-search--input--latitude').val();
        var lon = $('.suggestive-search--input--longitude').val();

        AAAP.form.clearMapMarkers();

        AAAP.map
            .getService()
            .moveMarker($('[id$="baddress"]').val(), {
                street: $('[id$="bstreet"]').val(),
                city: $('[id$="bcity"]').val(),
                state: $('[id$="bstate"]').val(),
                county: $('[id$="bcounty"]').val(),
                zip: $('[id$="bzip"]').val(),
                lat: lat,
                lon: lon
            })
            .then(function (marker) {
                AAAP.table.initialize(marker.location);
                AAAP.map.container.show();
            })
            .catch(function (error) {
                console.error(error);
            });
    });
};

AAAP.form.initSearchLocation = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file initSearchLocation() starting...');

    var list = $('.suggestive-search--address-results');
    var last = 0;

    $('.suggestive-search--input')
        .on('blur', function () {
            list.hide();
        })
        .on('keyup', function () {
            var value = $(this).val();

            if (value.length > 3) {
                last++;
                var current = last;
                AAAP.map
                    .getService()
                    .suggest({ singleLineAddress: value })
                    .then(function (response) {
                        if (current === last) {
                            if (response.length > 0) {
                                list.show();
                            } else {
                                list.hide();
                            }

                            // Reset list.
                            list.html('');

                            // Process list of addresses.
                            for (var i = 0; i < response.length; i++) {
                                if (AAAP.form.isInRlp(response[i].text)) {
                                    // Create new list item.
                                    var element = $('<li></li>');

                                    // Append list item to list.
                                    list.append(element);

                                    // Set text and attach click handler.
                                    element
                                        .text(response[i].text)
                                        .on('mousedown', function (event) {
                                            event.preventDefault();
                                        })
                                        .on('click', function () {
                                            //this function is called when a user clicks on a suggested address from the dropdown. Then the map is rendered with the marker.
                                            AAAP.form.clearMapMarkers();//removed June 2021

                                            // Add marker to the map.
                                            let doubleClick = false;
                                            AAAP.map
                                                .getService()
                                                .addMarker($(this).text(), doubleClick)
                                                .then(
                                                    function (marker) {
                                                        AAAP.table.initialize(marker.location);//table is set with the address that was chosen from the suggestions dropdown
                                                        AAAP.map.container.show();
                                                    }.bind(this)
                                                )
                                                .catch(function (err) {
                                                    console.error(err);
                                                });

                                            // Hide the list.
                                            list.hide().html('');

                                            // Set the input to selected value.
                                            $('.suggestive-search--input').val($(this).text());

                                            // Show the accept button.
                                            $('#accept-address').show();
                                        });
                                }
                            }
                        }
                    })
                    .catch(function (err) {
			alert('An error occurred attempting to retrieve address suggestions. Please refresh this page and try again.  If complications persist, please email LOP.Help@gsa.gov or call 1-866-450-6588 and select option 7. ');
                        console.error(err);
                    });
            } else {
                // Reset list.
                list.hide().html('');
            }
        });

    var coord_addresses = $('.suggestive-search--coordinate-results');
    /*
      $(
        [
          '.suggestive-search--input--longitude',
          '.suggestive-search--input--latitude'
        ].join(', ')
      )
        .on('blur', function() {
          coord_addresses.hide();
        })
        .on('keyup', function() {
          var lat = $('.suggestive-search--input--latitude').val();
          var lon = $('.suggestive-search--input--longitude').val();
    
          if (
            lat.length > 0 &&
            lon.length > 0 &&
            parseFloat(lat) <= 90 &&
            parseFloat(lat) >= -90 &&
            parseFloat(lon) <= 180 &&
            parseFloat(lon) >= -180
          ) {
            last++;
            var current = last;
            AAAP.map
              .getService()
              .suggest({ lat: lat, lon: lon })
              .then(function(response) {
                if (current === last) {
                  if (response.length > 0) {
                    coord_addresses.show();
                  } else {
                    coord_addresses.hide();
                  }
    
                  // Reset list.
                  coord_addresses.html('');
    
                  // Process list of addresses.
                  for (var i = 0; i < response.length; i++) {
                    if (
                      AAAP.form.isInRlp(
                        response[i].parts.street,
                        response[i].parts.city,
                        response[i].parts.state,
                        response[i].parts.zip
                      )
                    ) {
                      // Create new list item.
                      var element = $('<li></li>');
    
                      // Append list item to list.
                      coord_addresses.append(element);
    
                      // Set text and attach click handler.
                      element
                        .text(response[i].address)
                        .on('mousedown', function(event) {
                          event.preventDefault();
                        })
                        .on('click', function() {
                          AAAP.form.clearMapMarkers();
    
                          // Add marker to the map.
                          AAAP.map
                            .getService()
                            .addMarker($(this).text())
                            .then(
                              function(marker) {
                                AAAP.table.initialize(marker.location);
                                AAAP.map.container.show();
                              }.bind(this)
                            )
                            .catch(function(err) {
                              console.error(err);
                            });
    
                          // Hide the list.
                          coord_addresses.hide().html('');
    
                          // Set the input to selected value.
                          $('.suggestive-search--input').val($(this).text());
    
                          // Show the accept button.
                          $('#accept-address').show();
                        });
                    }
                  }
                }
              })
              .catch(function(err) {
                console.error(err);
              });
          } else {
            // Reset list.
            coord_addresses.hide().html('');
          }
        });
      */
};

/**
 * Set the location values.
 */
AAAP.form.setLocation = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file setLocation() starting...');

    this.location = {
        street: $('input[id$="bstreet"]').val(),
        city: $('input[id$="bcity"]').val(),
        state: $('input[id$="bstate"]').val(),
        zip: $('input[id$="bzip"]').val(),
        county: $('input[id$="bcounty"]').val()
    };
};

var rlpRegionMap = [];

/**
 * rlp change event is fired by the rlp select.
 */
AAAP.form.rlpChanged = function () {
    
console.log('Todd testing. ArcGIS v4.19 Interface JS file rlpChanged() starting...');

    var rlp = $('select[id$="chooseRLP"]')
        .children(':selected')
        .text();

    var region = rlpRegionMap[rlp];

    if (
        region === 'Census' &&
        !window.confirm(
            'You have selected the Census 2020 RLP. Offers using this RLP will only apply to Census 2020 opportunities listed at https://www.gsa.gov/census2020.'
        )
    ) {
        location.reload(true);
    }

    AAAP.form.initialize(false);
};

var isInRlpCache = {};
/**
 *
 */
AAAP.form.isInRlp = function (fullAddress, state, city, subregion) {

console.log('Todd testing. ArcGIS v4.19 Interface JS file isInRlp() starting...');

    var selectedRlp = $('[id$="chooseRLP"]>span').text();

    if (state == null && city == null && subregion == null) {
        // expected format is [77 Massachusetts St S, Staten Island, NY, 10307, USA]
        var addressParts = (fullAddress + '').split(',');
        state = addressParts[2];
        city = addressParts[1];
    }
    state = (state + '').toLowerCase().trim();
    city = (city + '').toLowerCase().trim();
    subregion = (subregion + '').toLowerCase().trim();
    console.log('state ', state);
    console.log('city ', city);
    console.log('subregion ', subregion);
    var region = rlpRegionMap[selectedRlp];
    console.log('region ', region);
    var cacheKey = state + ';' + city + ';' + subregion + ';' + region;
    console.log('cacheKey ', cacheKey);
    var cacheVal = isInRlpCache[cacheKey];
    console.log('cacheVal ', cacheVal);
    //Added
    var arrayToExclude = [];
    for (z in areas) {
        var area = areas[z];
        if ((area.r == "National Capital Region" || area.r == "Region 2") && (area.t == 'city' || area.t == 'county')) {
            arrayToExclude.push(area);
        }
    }
    console.log('area ', area);
    console.log('arrayToExclude ', arrayToExclude);
    //Added
    var cacheHit = cacheVal === true || cacheVal === false;
    var inRlp = cacheVal === true;
    if (!cacheHit) {
        //added
        var isContinue = true;
        if (region == "Region 3") {
            for (excludeIndex in arrayToExclude) {
                if (arrayToExclude[excludeIndex].t == 'city' && arrayToExclude[excludeIndex].c.toLowerCase() == city ||
                    (arrayToExclude[excludeIndex].t == 'county' && arrayToExclude[excludeIndex].c.toLowerCase() == subregion)) {
                    isContinue = false;
                }
            }
        }
        //console.log('isContinue ' + isContinue);
        //added
        if ((state != '' || city != '' || subregion != '') && isContinue) {
            for (z in areas) {
                var a = areas[z];
                if (a.r != region) continue;
                inRlp = inRlp || (a.t == 'state' && a.s.toLowerCase() == state);
                inRlp = inRlp || (a.t == 'city' && a.c.toLowerCase() == city);
                inRlp = inRlp || (a.t == 'county' && a.c.toLowerCase() == subregion);
                if (inRlp) break;
            }
        }
        isInRlpCache[cacheKey] = inRlp;
    }

    return inRlp;
};

//Interface Offer Building Section 3: Formerly PBS_AAAP_OfferBuilding_419.js
//console.log('Map_419 section load ');

/*AAAP.map = {
  container: null,
  service: null
};*/

/**
 * Initialize map.
 */
AAAP.map.initialize = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file AAAP.map.initialize() starting...');

    this.container = $('[id$="map_canvas"]');

    this.container.hide();
    this.service = this.setService(this.container.attr('id'));
    // Initialize map service.

    this.getService()
        .init()
        .then(function (instance) {
            //console.log('map service initialized', instance);
        })
        .catch(function (err) {
            //console.log(err);
        });

        //layers have been removed June 2021
    // Attach event handler for topo-vector view.
    //removing event handlers for views
    /*$('#view-topo-vector').on(
        'click',
        function () {
            this.setView('topo-vector');
        }.bind(this)
    );*/
    // Attach event handler for hybrid view.
   /* $('#view-hybrid').on(
        'click',
        function () {
            this.setView('hybrid');
        }.bind(this)
    );
    // Attach event handler for flood plain layer.
    $('#layer-flood').on('click', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
            AAAP.map.hideLayer('FloodZoneLayer');
        } else {
            $(this).addClass('active');
            AAAP.map.showLayer('FloodZoneLayer');
        }
    });

    // Attach event handler for seismic layer.
    $('#layer-seismic').on('click', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
            AAAP.map.hideLayer('SeismicLayer');
        } else {
            $(this).addClass('active');
            AAAP.map.showLayer('SeismicLayer');
        }
    });
    // Attach event handler for seismic layer.
    $('#layer-cbd').on('click', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
            AAAP.map.hideLayer('CentralBusinessDistrictLayer');
        } else {
            $(this).addClass('active');
            AAAP.map.showLayer('CentralBusinessDistrictLayer');
        }
    });

    // Attach event handler for seismic layer.
    $('#layer-transit').on('click', function () {
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
            AAAP.map.hideLayer('TransitLayer');
        } else {
            $(this).addClass('active');
            AAAP.map.showLayer('TransitLayer');
        }
    });*/
};

AAAP.map.setService = function (container) {

console.log('Todd testing. ArcGIS v4.19 Interface JS file AAAP.map.setService() starting...');

    return new ArcGIS_v4_19({
        //this is where the class is instantiated from the interface file newPoint is the default when page loads, for when the map needs to be rendered on page load. SF_Label is set in the Javascript on the Visualforce page
        container: container,
        locatorUrl: SF_Label.locator.WORLD,
        newPoint: {
            longitude: undefined,
            latitude: undefined
        },//"https://extgsagis.gsa.gov/extgsagis/rest/services/Base/USA/GeocodeServer"
        click: function (marker) {//this was previously used with the double click functionality. This section is commented out because the marker is no longer removed in removeMarker(), but in addMarker()
            /*var service = AAAP.map.getService();//here it is calling getService and passing marker as the param-ONCLICK
            for (var key in service.markers) {
                //this iterates through all the markers, and passes the marker 'key' to removeMarker. removeMarker then takes the key and 
                if (key !== marker.id) {
                    console.log('we are removing the marker with this key: ', key);
                    service.removeMarker(key);
                }
            }*/
            //This section has been added as a custom solution to the onclick refresh page behavior. When a user clicks on the title of the popup after doubleclicking the page refreshings, which is not expected behavior. Here the page refresh is being prevented.
            let elements = document.getElementsByClassName('esri-component')
            for(let i=0; i < elements.length; i++){
                if(elements[i].className === 'esri-component esri-popup'){
                    elements[i].addEventListener('click', function(event){
                        event.preventDefault();
                    })
                }
            }
            AAAP.table.initialize(marker.location);
        }
    });
};
AAAP.map.getService = function () {

console.log('Todd testing. ArcGIS v4.19 Interface JS file AAAP.map.getService() starting...', this.service);

    return this.service;
};

/**
 *
 */
AAAP.map.setView = function (view) {

console.log('Todd testing. ArcGIS v4.19 Interface JS file AAAP.map.setView() starting...');

    this.service.setView(view);

    switch (view) {
        case 'hybrid': this.service.addLayer('TransportationLayer'); break;
        default:
            this.service.removeLayer('TransportationLayer');
    }

    $('.map--view-item').css('font-weight', 'normal');
    $('#view-' + view).css('font-weight', 'bold');
};

AAAP.map.showLayer = function (layer) {
    this.service.addLayer(layer);
};

AAAP.map.hideLayer = function (layer) {
    this.service.removeLayer(layer);
};

//Metro Data is no longer needed, this was confirmed with the business owner in June 2021
/*
AAAP.map.getMetroData = function(lat, lng) {
  require([
    "esri/tasks/Geoprocessor",
    "esri/geometry/webMercatorUtils"
  ], function(Geoprocessor, WebMercatorUtils) {
    var latLngXY = WebMercatorUtils.lngLatToXY(lng, lat);
    var inputLocation = {
      displayFieldName: "",
      geometryType: "esriGeometryPoint",
      spatialReference: {
        wkid: 102100
      },
      fields: [
        {
          name: "OBJECTID",
          type: "esriFieldTypeOID",
          alias: "OBJECTID"
        }
      ],
      features: [
        {
          attributes: {
            OBJECTID: "1"
          },
          geometry: {
            x: latLngXY[0],
            y: latLngXY[1]
          }
        }
      ],
      exceededTransferLimit: false
    };
    var bufferDistance = {
      distance: 0.75,
      units: "esriMiles"
    };
    var paramsGP = {
      Input_Features: JSON.stringify(inputLocation),
      Buffer_Distance: JSON.stringify(bufferDistance)
    };

    esri.config.defaults.io.timeout = 300000;

    new Geoprocessor(SF_Label.locatorUrl).execute(
      paramsGP,
      function(results) {
        var distanceMeter =
          results[1].value.features[0].attributes.Total_Kilometers * 1000;
        console.log(
          "KM: " +
            JSON.stringify(
              results[1].value.features[0].attributes.Total_Kilometers
            )
        );
        if (distanceMeter <= METERTHRESHOLD) {
          AAAP.map.closeToMetro = true;
        }
        refresh(
          AAAP.form.location.street,
          AAAP.form.location.city,
          AAAP.form.location.state,
          AAAP.form.location.zip,
          AAAP.form.location.lat,
          AAAP.form.location.lng,
          AAAP.map.closeToMetro
        );
      },
      function(err) {
        refresh(
          AAAP.form.location.street,
          AAAP.form.location.city,
          AAAP.form.location.state,
          AAAP.form.location.zip,
          AAAP.form.location.lat,
          AAAP.form.location.lng,
          AAAP.map.closeToMetro
        );
        console.log("No Results from Metro Service: " + err.message);
      }
    ); //end execute
  }); //end require
};
*/

//Interface Offer Building Section 4: Formerly PBS_AAAP_OfferBuilding_Table_419.js

/*AAAP.table = {
  container: null
};*/

AAAP.table.initialize = function (address) {
    
console.log('Todd testing. initialize table', address);

    address.confirm = '<button style="cursor:pointer" onclick="return false;">Confirm Address</button>';
    this.container = $('[id$="table_canvas"]');

    this.container.show();

    if (this.addressTable) {
        this.addressTable.clear().draw();
        this.addressTable.rows.add([address]); // Add new data
        this.addressTable.columns.adjust().draw(); // Redraw the DataTable
    } else {
        this.addressTable = $('#addressTable').DataTable({
            bPaginate: false,
            bSort: false,
            searching: false,
            data: [address],
            retrieve: true,
            columns: [
                { data: 'street' },
                { data: 'city' },
                { data: 'state' },
                { data: 'zip' },
                { data: 'county' },
                { data: 'lat' },
                { data: 'lon' },
                { data: 'confirm' }
            ]
        });
    }

    AAAP.setAddressFields(address);

    $('#addressTable tbody')
        .off('click.rowClick')
        .on('click.rowClick', 'tr', function () {
            AAAP.table.rowClick();
        });
};

AAAP.table.rowClick = function () {
    var addr = this.addressTable.row(this).data();
    //console.log('row click', addr);

    var fullAddress =
        addr.street + ', ' + addr.city + ', ' + addr.state + ' ' + addr.zip;

    var confirmed = confirm(
        'Confirm Selected Address\n' +
        'Are you sure you wish to confirm the following ' +
        $('[id$="chooseRLP"]>span').text() +
        ' address?\n' +
        fullAddress
    );

    if (confirmed) {
        var rlp = $('select[id$="chooseRLP"]')
            .children(':selected')
            .text();

        var inRlp = AAAP.form.isInRlp(null, addr.state, addr.city, addr.county);

        if (!inRlp) {
            alert(
                'The address you selected is not in the given RLP.  Please enter a different property for consideration in ' +
                rlp +
                '.'
            );
            AAAP.map.container.hide();
            AAAP.table.container.hide();
        } else {
            AAAP.map.container.hide();
            $('[id$="other_bldg_data"]').show();
            $('#show-map').show();

            AAAP.setAddressFields(addr);

            var cds = AAAP.map.getService().layers.CongressionalDistrictLayer;

            //added this logic because layers are currently commented out as of June 2021
            if (cds !== undefined) {
                for (var i = 0; i < cds.length; i++) {
                    if (cds[i].geometry.contains(addr.geometry)) {
                        // Add state to the district number (Ex.: PA-13)
                        $('[id$="bdistrict"]').val(
                            addr.state + '-' + cds[i].attributes.cd116fp
                        );
                    }
                }
            }
        }
    }

    var isValidRLP;

    /*
    Visualforce.remoting.Manager.invokeAction(
      //Invoking controller action getcon
      SF_RemoteActions.checkisValidRegion,
      addr.subregion,
      addr.state,
      rlp,
      function(result, event) {
        //We can access the records through the parameter result
        //event.status determines if there is error or not
        if (event.status) {
          isValidRLP = result;
  
          var confirmTxt =
            'Confirm Selected Address ' +
            '\r' +
            'Are you sure you wish to confirm the following ' +
            rlp +
            ' address:' +
            '\r' +
            addr.street +
            ', ' +
            addr.city +
            ', ' +
            addr.state +
            ' ' +
            addr.zip;
  
          var confirmAddress = confirm(confirmTxt);
  
          if (confirmAddress && inRlp && isValidRLP) {
            AAAP.form.location.street = addr.street;
            AAAP.form.location.city = addr.city;
            AAAP.form.location.state = addr.state;
            AAAP.form.location.zip = addr.zip;
            AAAP.form.location.lat = addr.Y;
            AAAP.form.location.lng = addr.X;
  
            AAAP.map.container.hide();
            AAAP.table.container.hide();
            $('[id$="other_bldg_data"]').show();
  
            refresh(
              AAAP.form.location.street,
              AAAP.form.location.city,
              AAAP.form.location.state,
              AAAP.form.location.zip,
              AAAP.form.location.lat,
              AAAP.form.location.lng,
              AAAP.table.closeToMetro
            );
  
            AAAP.map.getMetroData(AAAP.form.location.lat, AAAP.form.location.lng);
  
            $('[id$="bstreet"]').val(addr.street);
            $('[id$="bcity"]').val(addr.city);
            $('[id$="bstate"]').val(addr.state);
            $('[id$="bzip"]').val(addr.zip);
            $('[id$="bYCood"]').val(addr.lat);
            $('[id$="bXCood"]').val(addr.lon);
          } else {
            if (!inRlp || !isValidRLP) {
              alert(
                'The address you selected is not in the given RLP.  Please enter a different property for consideration in ' +
                  rlp +
                  '.'
              );
            }
            AAAP.map.container.hide();
            AAAP.table.container.hide();
          }
        }
      },
      { escape: true }
    );
    */
};

AAAP.setAddressFields = function (addr) {
    var fullAddress =
        addr.street + ', ' + addr.city + ', ' + addr.state + ' ' + addr.zip;

    $('[id$="baddress"]').val(fullAddress);

    $('[id$="bstreet"]').val(addr.street);
    $('[id$="bcity"]').val(addr.city);
    $('[id$="bstate"]').val(addr.state);
    $('[id$="bcounty"]').val(addr.county);
    $('[id$="bzip"]').val(addr.zip);
    $('[id$="bYCood"]').val(addr.lon);
    $('[id$="bXCood"]').val(addr.lat);
};


//added callback in June 2021 to ensure that the DOM is fully loaded
let callback = function () {
    AAAP.form.initialize(true)
    AAAP.map.initialize();

    sessionStorage.setItem('addrFlag', !($('input[id$="bldMsg"]').val() == ''));

    if ($('input[id$="draftMsgFlag"]').val() == 'true') {
        //.html: Get the HTML contents of the first element in the set of matched elements or set the HTML contents of every matched element.
        //.dialog: JQuery: Open content in an interactive overlay.
        $('<div></div>')
            .html(
                "Your offer is no longer submitted. Offer status is updated to 'Draft' status and needs to be submitted again."
            )
            .dialog({
                autoOpen: false,
                title: '',
                modal: true,
                position: ['center', 'center'],
                buttons: {
                    OK: function () {
                        $(this).dialog('close');
                    }
                }
            })
            .dialog('open');
    }

};

if (
    document.readyState === "complete" || document.readyState === "interactive" ||
    (document.readyState !== "loading" && !document.documentElement.doScroll)
) {
    //console.log('doc readyState is complete or not loading');
    callback();
} else {
    //console.log('doc readyState is not complete or loading');
    document.addEventListener("DOMContentLoaded", callback);
}


