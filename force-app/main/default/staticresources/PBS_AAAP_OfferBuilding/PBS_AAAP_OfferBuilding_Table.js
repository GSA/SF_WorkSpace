var AAAP = AAAP ? AAAP : {};

AAAP.table = {
  container: null
};

AAAP.table.initialize = function(address) {
  console.log('initialize table', address);

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
    .on('click.rowClick', 'tr', function() {
      AAAP.table.rowClick();
    });
};

AAAP.table.rowClick = function() {
  var addr = this.addressTable.row(this).data();
  console.log('row click', addr);

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

      var cds = AAAP.map.getService().congressionalDistricts;

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

AAAP.setAddressFields = function(addr) {
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
