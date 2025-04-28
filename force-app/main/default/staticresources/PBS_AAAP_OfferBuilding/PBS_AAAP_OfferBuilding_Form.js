var AAAP = AAAP ? AAAP : {};

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

/**
 * Initialize the form.
 */
AAAP.form.initialize = function(initialLoad) {
  if (initialLoad) {
    // Set form.
    this.container = $('[id$="newOffer"]');

    // Disable autocomplete on form level.
    this.container.attr('autoComplete', 'off');

    this.initSearchButtons();
    this.initSearchLocation();

    // added by syam to fix the calendar issue with the uniform style
    // class to the select components. so we omitted calendar select
    // fields from applying uniform style class.
    $('select').each(function() {
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
      .each(function(input) {
        $(this).on('keyup', function() {
          $('[id$="other_bldg_data"]').hide();
        });
      });

    $('select[id$="chooseRLP"]').on(
      'change',
      function() {
        this.rlpChanged();
      }.bind(this)
    );

    $('#accept-address').on('click', function() {
      AAAP.map.container.hide();
      $('[id$="other_bldg_data"]').show();
      $(this).hide();
      $('#show-map').show();
    });

    $('#show-map').on('click', function() {
      AAAP.map.container.show();
      $(this).hide();
      $('#accept-address').show();

      var address = $('.suggestive-search--input.address').val();

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
        .then(function(marker) {
          AAAP.table.initialize(marker.location);
          AAAP.map.container.show();
        })
        .catch(function(error) {
          console.error(error);
        });
      }
    });

    $('#show-latlon').on('click', function() {
      $('#coordinate-container').show();
      $(this)
        .parent()
        .hide();
    });

    $('#cancel-coordinates').on('click', function() {
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

AAAP.form.clearMapMarkers = function() {
  var markers = Object.keys(AAAP.map.getService().markers);

  for (var i = 0; i < markers.length; i++) {
    AAAP.map.getService().removeMarker(markers[i]);
  }
};

AAAP.form.initSearchButtons = function() {
  $('#submit-address').on('click', function() {
    var address = $('.suggestive-search--input.address').val();

    AAAP.form.clearMapMarkers();

    AAAP.map
      .getService()
      .search({ singleLineAddress: address })
      .then(function(marker) {
        AAAP.table.initialize(marker.location);
        AAAP.map.container.show();
      })
      .catch(function(error) {
        console.error(error);
      });
  });

  $('#submit-coordinates').on('click', function() {
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
      .then(function(marker) {
        AAAP.table.initialize(marker.location);
        AAAP.map.container.show();
      })
      .catch(function(error) {
        console.error(error);
      });
  });
};

AAAP.form.initSearchLocation = function() {
  var list = $('.suggestive-search--address-results');
  var last = 0;

  $('.suggestive-search--input')
    .on('blur', function() {
      list.hide();
    })
    .on('keyup', function() {
      var value = $(this).val();

      if (value.length > 3) {
        last++;
        var current = last;
        AAAP.map
          .getService()
          .suggest({ singleLineAddress: value })
          .then(function(response) {
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
          .catch(function(err) {
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
AAAP.form.setLocation = function() {
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
AAAP.form.rlpChanged = function() {
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
AAAP.form.isInRlp = function(fullAddress, state, city, subregion) {
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

  var region = rlpRegionMap[selectedRlp];
  var cacheKey = state + ';' + city + ';' + subregion + ';' + region;

  var cacheVal = isInRlpCache[cacheKey];

	//Added
	var arrayToExclude = [];
	for (z in areas) {
			var area = areas[z];
		if(area.r == "National Capital Region" && (area.t == 'city' || area.t == 'county')){
			arrayToExclude.push(area);
		}
	}
	//Added
  var cacheHit = cacheVal === true || cacheVal === false;
  var inRlp = cacheVal === true;
  if (!cacheHit) {
  //added
	var isContinue = true;
	if(region == "Region 3"){
		for(excludeIndex in arrayToExclude){
			if(arrayToExclude[excludeIndex].t == 'city' && arrayToExclude[excludeIndex].c.toLowerCase() == city || 
			(arrayToExclude[excludeIndex].t == 'county' && arrayToExclude[excludeIndex].c.toLowerCase() == subregion) ){
				isContinue = false;
			}
		}
	}
	console.log('isContinue '+isContinue);
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
