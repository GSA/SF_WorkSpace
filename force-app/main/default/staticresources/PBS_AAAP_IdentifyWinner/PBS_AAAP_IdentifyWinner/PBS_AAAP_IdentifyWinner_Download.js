//added by syam for jSPDF
function pdfDownload() {
  var canvasToImage = function(canvas) {
    var img = new Image();

    img.setAttribute('crossOrigin', 'anonymous');
    img.src = canvas.toDataURL('image/png');

    return img;
  };

  var canvasShiftImage = function(oldCanvas, shiftAmt) {
    shiftAmt = parseInt(shiftAmt) || 0;

    if (!shiftAmt) {
      return oldCanvas;
    }

    var newCanvas = document.createElement('canvas');
    newCanvas.height = oldCanvas.height - shiftAmt;
    newCanvas.width = oldCanvas.width;

    var img = canvasToImage(oldCanvas);

    newCanvas
      .getContext('2d')
      .drawImage(
        img,
        0,
        shiftAmt,
        img.width,
        img.height,
        0,
        0,
        img.width,
        img.height
      );

    return newCanvas;
  };

  var canvasToImageSuccess = function(canvas) {
    var pdf = new jsPDF('l', 'px'),
      pdfInternals = pdf.internal,
      pdfPageSize = pdfInternals.pageSize,
      pdfScaleFactor = pdfInternals.scaleFactor,
      pdfPageWidth = pdfPageSize.width,
      pdfPageHeight = pdfPageSize.height,
      totalPdfHeight = 0,
      htmlPageHeight = canvas.height,
      htmlScaleFactor = canvas.width / (pdfPageWidth * pdfScaleFactor),
      safetyNet = 0;

    while (totalPdfHeight < htmlPageHeight && safetyNet < 15) {
      var newCanvas = canvasShiftImage(canvas, totalPdfHeight);

      pdf.addImage(newCanvas, 0, 0, pdfPageWidth, 0, 'png', safetyNet, 'SLOW');

      totalPdfHeight += pdfPageHeight * pdfScaleFactor * htmlScaleFactor;

      if (totalPdfHeight < htmlPageHeight) {
        pdf.addPage();
      }

      safetyNet++;
    }

    var d = new Date();
    var dformat =
        [
          (d.getMonth() + 1).padLeft(),
          d.getDate().padLeft(),
          d.getFullYear()
        ].join('/') +
        ' ' +
        [
          d.getHours().padLeft(),
          d.getMinutes().padLeft(),
          d.getSeconds().padLeft()
        ].join(':');
    
    var projectId = $('[id$="projectId"]').val();

    pdf.save('IdentifyWinner-' + projectId + '-' + dformat + '.pdf');
  };

  html2canvas($('#pdfIdentifyWinner')[0], {
    useCORS: true,
    allowTaint: false,
    logging: true,
    onrendered: function(canvas) {
      canvasToImageSuccess(canvas);
      $('#ignoreMap').show();
    }
  });
  
  return true;
}

function pdfDownload1() {
  var doc = new jsPDF();

  var elementHandler = {
    '#Search': function() {
      return true;
    }
  };

  var source = $('#pdfIdentifyWinner').html();

  doc.fromHTML(source, 15, 15, {
    width: 180,
    elementHandlers: elementHandler
  });

  doc.output('dataurlnewwindow');
}
