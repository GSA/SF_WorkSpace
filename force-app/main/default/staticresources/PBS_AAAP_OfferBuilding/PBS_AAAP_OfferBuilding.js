$(document).ready(function() {
  AAAP.form.initialize(true);
  AAAP.map.initialize();

  sessionStorage.setItem('addrFlag', !($('input[id$="bldMsg"]').val() == ''));

  if ($('input[id$="draftMsgFlag"]').val() == 'true') {
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
          OK: function() {
            $(this).dialog('close');
          }
        }
      })
      .dialog('open');
  }
});
