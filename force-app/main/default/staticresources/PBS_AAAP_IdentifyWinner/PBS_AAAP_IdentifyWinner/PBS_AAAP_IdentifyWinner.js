var AAAPGMAP = AAAPGMAP || {};

var mapDiv = $('[id$="map_canvas"]')[0];
var shape = [];
var map, tool, toolbar, editToolbar, symbols;
var selectCellSelector = "td[id$='selectColumn'],th[id$='selectColumnheader']";
var props;
var offerstr = '';
var selectedSpacedIds;
var selectedofferdIds;

// saving List of offers select
var spaceparam;
var offerparam;
var costparam;


Number.prototype.padLeft = function(base, chr) {
  var len = String(base || 10).length - String(this).length + 1;
  return len > 0 ? new Array(len).join(chr || '0') + this : this;
};

$(document).ready(function() {
  shape = SF.Shape;
  props = SF.Props;

  console.log('doc ready shape', shape);

  $(selectCellSelector).css('display', 'none');

  if (shape) {
    $('#btn_rend_props').show();
  } else {
    $('#btn_rend_props').hide();
  }

  $(mapDiv).hide();

  //added by syam 06/07/2016 to enable or disable Proximity to Metro within 2640ft
  //enable only if the region is NCR else disable
  //var region = $('#regionId').val();
  var region = $('[id$="regionId"]').val();
  if (region == 'National Capital Region') {
    $('#metroArea').prop('disabled', false);
  } else {
    $('.metroArea').prop('disabled', true);
  }

  //added by syam on 09/30/2016 to disable the HVAC if the RLP Year greater than 2016
  var rlpAfter2016 = $('[id$="rlpAfter2016"]').val();
  if (rlpAfter2016 == 'true') {
    $('input.HVACOT').attr('checked', false);
    $('input.HVACOT').attr('disabled', true);
  } else {
    $('.HVACOT').prop('disabled', false);
  }

  $('.numericField').on('keypress', function(key) {
    val = $(this).val();

    if (key.charCode == 13) {
      if (isNaN(val) || val < 0 || val > 999.99) {
        alert(
          'Per ABOA SF rates are required, not lump sum values. Amounts greater than $999.99 will not be accepted by the system.'
        );

        $(this).val(0);

        location.reload(true);

        return false;
      }
    }
  });
});

function limitFive(val) {
  if (isNaN(val) || val < 0 || val > 999.99) {
    alert(
      'Per ABOA SF rates are required, not lump sum values. Amounts greater than $999.99 will not be accepted by the system.'
    );
    val = 0;
    location.reload(true);
  }
}

function snapshot(Id) {
    console.log('JK snapshot() start');
  var off = [];

  var unique = function(list) {
    var result = [];
    $.each(list, function(i, e) {
      if ($.inArray(e, result) == -1) result.push(e);
    });
    return result;
  };
  //JK was 3, changed to 2 on 10.7.20 because we took out the 'Rank' column
  $('tr.dataRow > td:nth-child(2)')
    .find('a:visible')
    .each(function() {
      console.log(
        'a03' +
          $(this)
            .attr('href')
            .split('/a03')
            .pop()
      );
      off.push(
        'a03' +
          $(this)
            .attr('href')
            .split('/a03')
            .pop()
      );
    });
  if (off.length === 0) {
    alert(
      'ID winner cannot be saved because there are no offers that fall within the specified area'
    );
  } else {
    var uniOff = unique(off);
    var offStr = uniOff.toString();

    snapshotmethod(Id, offStr);
  }
}

function pdfGen() {
    console.log('JK pdfGen() start ');
  var offer = [];
  //JK changing the nth-child to 2 10.7.2020, same as above
  $('tr.dataRow > td:nth-child(2)')
    .find('a:visible')
    .each(function() {
      console.log(
        'a03' +
          $(this)
            .attr('href')
            .split('/a03')
            .pop()
      );
      offer.push(
        'a03' +
          $(this)
            .attr('href')
            .split('/a03')
            .pop()
      );
    });

  var selSpacedIds = [];
  var selofferdIds = [];
  var allCheckbox = document.querySelectorAll('[cbox="offer"]');

  for (var i = 0; i < allCheckbox.length; i++) {
    var val = allCheckbox[i];
    if (val.checked) {
      selSpacedIds.push(val.getAttribute('space'));
      selofferdIds.push(val.getAttribute('offer'));
    }
  }

  var removeDuplicates = function(arr) {
    let unique_array = [];
    for (let i = 0; i < arr.length; i++) {
      if (unique_array.indexOf(arr[i]) == -1) {
        unique_array.push(arr[i]);
      }
    }
    return unique_array;
  };

  // removing unique
  var uniqueOfferArray = removeDuplicates(selofferdIds);
  selectedofferdIds = uniqueOfferArray.join();
  selectedSpacedIds = selSpacedIds.join();

  if (selectedofferdIds.length !== 0 && selectedSpacedIds.length !== 0) {
    // making apex method al to get offer, spaces, rate
    Visualforce.remoting.Manager.invokeAction(
      SF.fetchCookieData,
      selectedofferdIds,
      selectedSpacedIds,
      function(result, event) {
        if (event.status) {
          // getting count for total offers, space, rate ( forms and pv links are not displayed as it is not part of requirement )
          var allIds = result.split(';');
          var OfferCount = allIds[0];
          var spaceCount = allIds[1];
          var rateCount = allIds[2];

          document.getElementById('modalText').innerHTML =
            'Total Number of screen shot is <br/>Offers : ' +
            OfferCount +
            ' <br/>Space ' +
            spaceCount +
            ' <br/>Rate ' +
            rateCount;
          document.getElementById('myModal').style.display = 'block';
        } else if (event.type === 'exception') {
          alert(event.message + '<br/>\n<pre>' + event.where + '</pre>');
        } else {
          alert(event.message);
        }
      },
      { escape: true }
    );
  } else {
    alert(
      'Please select the Offers you wish to capture by selecting the boxes on the left side of the table.'
    );
  }
}

function openScreenShotPage() {
  var visibleSpaces = [];
  $('tr.dataRow > td:nth-child(1)')//JK no change - because this gets the first column which is not affected by the removed 'Rank' column
    .find('input:visible')
    .each(function() {
      visibleSpaces.push($(this).attr('space'));
    });
  console.log('&*&*&*' + visibleSpaces);

  var history = SF.selectedHistorical;
  console.log('&*&*&*' + history);

  var replaceAll = function(str, term, replacement) {
    return str.replace(
      new RegExp(term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'),
      replacement
    );
  };

  Visualforce.remoting.Manager.invokeAction(
    SF.fetchCookieData,
    selectedofferdIds,
    selectedSpacedIds,
    function(result, event) {
      if (event.status) {
        // results of offers, spaces, rates in same sequense
        var spiltRes = result.split(';');
        var allIds = spiltRes[3].split(',');

        /** code to get space ids **/
        var selspaceids = [];
        var offerRecids = [];
        for (var i = 0; i < allIds.length; i++) {
          var preFix = allIds[i].substring(0, 3);
          if (preFix == SF.Label.SpaceKeyPrefix) {
            selspaceids.push(allIds[i]);
          } else if (preFix == SF.Label.OfferKeyPrefix) {
            offerRecids.push(allIds[i]);
          }
        }

        var urls = [];

        // *************** section to get Link for PV **************/
        var urlsArray = document.querySelectorAll('[Link="copyLink"]');

        console.log('1>>>>>>' + urlsArray.length);
        console.log('2>>>>>>' + offerRecids);

        var pushedOffer = [];

        for (var ele in offerRecids) {
          var oId = offerRecids[ele];
          console.log('3>>>>>>' + ele);
          console.log('4>>>>>>' + oId);
          for (var i = 0; i < urlsArray.length; i++) {
            var val = urlsArray[i];
            if (selspaceids.indexOf(val.getAttribute('sId')) != -1) {
              var url = val.href.replace(
                'PBS_AAAP_PV_Summary_Page',
                'PBS_AAAP_PV_Summary_PageImage'
              );

              url = replaceAll(url, '=', '#');

              if (url.indexOf(oId) != -1) {
                console.log('#>>>>>>' + pushedOffer.length);
                console.log('#>>>>>>' + pushedOffer.indexOf(oId));
                if (pushedOffer.length == 0 || pushedOffer.indexOf(oId) == -1) {
                  urls.push(url);
                  pushedOffer.push(oId);
                }
              }
            }
          }
        }

        console.log('5>>>>>>' + pushedOffer);
        console.log('6>>>>>>' + urls.length);
        console.log('7>>>>>>' + urls);

        var strURL = urls.join();
        var totallen = 0;

        if (parseInt(SF.rlpRecord.Year) >= 2019) {
          totallen = allIds.length + urls.length + offerRecids.length * 4 + 1;
        } else {
          totallen = allIds.length + urls.length + offerRecids.length * 3 + 1;
        }

        // combining all offers, space, rate in a string to store in cookie
        var stringArray = allIds.join();

        // making completedIds cookie
        document.cookie = 'apex__completeIds=';

        // making cookie for those for which we have to take screen shots.
        document.cookie = 'apex__offerIds=' + stringArray;
        document.cookie = 'apex__links=' + strURL;
        document.cookie = 'apex__agencyId=' + SF.CurrentPage.agencyId;
        document.cookie = 'apex__spaceids=' + selspaceids.join();
        document.cookie = 'apex__offerRecids=' + offerRecids.join();
        document.cookie = 'apex__RLPYear=' + SF.rlpRecord.Year;
        document.cookie = 'apex__histId=' + history;
        //closing modal
        $('#myModal').hide();
        // opening new scrren to take screen shots
        window.open(
          '/apex/PBS_AAAP_relatedListSnapShop?showSpaces=' +
            visibleSpaces +
            '&histId=' +
            history +
            '&agencyId=' +
            SF.CurrentPage.agencyId +
            '&current=1&total=' +
            totallen,
          '_blank'
        );
      } else if (event.type === 'exception') {
        alert(event.message + '<br/>\n<pre>' + event.where + '</pre>');
      } else {
        alert(event.message);
      }
    },
    { escape: true }
  );  
}

	function openSelectConfirmation(spacelocalparam, offerlocalparam, costlocalparam){     
			debugger;
            document.getElementById('selectModal').style.display = 'block';
            var modalTxt = "Selecting an Offer will export the Offeror's documentation to the associated GREX project.<br/><br/>Are you sure Project Number: {!agencyRecord.PBS_AAAP_Project_ID__c} is the correct GREX project number for this Agency Requirement? <br/>";
            document.getElementById('selectModalText').innerHTML = modalTxt;
			
			spaceparam = spacelocalparam ;
			offerparam = offerlocalparam;
			costparam = costlocalparam;
        }
		
		function closeSelectConfirmation(){
        	document.getElementById('selectModal').style.display = 'none';
        }
		
		function CallSelectConfirmation(){
            //alert(spaceparam+' '+offerparam+' '+costparam);
        	debugger;
			document.getElementById('pageid:form_ident_win:selectedSpaceId').value = spaceparam;
			document.getElementById('pageid:form_ident_win:selectedOfferId').value = offerparam;
			document.getElementById('pageid:form_ident_win:selectedPV').value = costparam;
			actionSelectSpaceActionFunction();
        }