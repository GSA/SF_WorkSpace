({
    init : function(cmp, evt, hlp) {
        //Default values if not passed in from url parameters
        if (cmp.get('v.selectedCostType') == null || cmp.get('v.selectedCostType') == '')
            cmp.set('v.selectedCostType', 'cost');

        cmp.set('v.displayCostType', cmp.get('v.selectedCostType'));
        if (cmp.get('v.selectedCostType') == 'cost')
            cmp.set('v.displayCostType', 'Constant Dollar');
        
        if (cmp.get('v.selectedCostType') == 'escalatedCost')
            cmp.set('v.displayCostType', 'Escalated Cost');
        if (cmp.get('v.selectedCostType') == 'escalatedDiscountedCost')
            cmp.set('v.displayCostType', 'Escalated &amp; Discounted Cost');

        cmp.set('v.reportType', 'ExpenditureCurveStacked');

        if (cmp.get('v.urlReportType') != null &&cmp.get('v.urlReportType') != '')
                cmp.set('v.reportType', unescape(cmp.get('v.reportType')));

        hlp.getReportData(cmp, evt, hlp);
    },

    reportChange :function(cmp, evt, hlp){
        cmp.set('v.isLoaded', false);
        hlp.getReportData(cmp, evt, hlp);
        
    },
    onRender: function(cmp, evt, hlp){
        var reportData = cmp.get('v.reportData');
        console.log(reportData);
        if (reportData != null){
            for (var i = 0; i < reportData.sections.length; i++){
                for (var q = 0; q < reportData.sections[i].charts.length; q++){
                    var chartDef = reportData.sections[i].charts[q];
                    var uniqueId = reportData.sections[i].charts[q].uniqueId;
                    
                    
                    chartDef.options.tooltips = {callbacks: {
                        label: function(tooltipItem, data) {
                            return tooltipItem.yLabel.toLocaleString("en-US",{style:"currency", currency:"USD"});
                        }}
                    };
                    
                    Chart.scaleService.updateScaleDefaults('linear', {
                        ticks: {
                            callback: function (value, index, values) {
                                return value.toLocaleString("en-US",{style:"currency", currency:"USD"});
                            }
                        }
                    });
                
                    var chartCanvas = document.getElementById(uniqueId); 
                    console.log(chartDef);
                    var auraChart = new Chart(chartCanvas, chartDef);
/*
                    for (var s = 0; s < auraChart.scales.length; s++){
                        for (var t = 0; t < auraChart.scales[s].y-axis-0.ticks.length; t++){
                            auraChart.scales[s].y-axis-0[t].callback = function(value, index, values) {
                                return value.toLocaleString("en-US",{style:"currency", currency:"USD"});
                            };
                        }
                    }*/
                }
                
            }
        }
    },
    printMe: function(cmp){
        var projId = cmp.get('v.id');
        var reportType = encodeURI(cmp.get('v.reportType'));
        
        window.open('apex/NCMT_TCO_ProjectDetails?print=true&id=' +projId +
                '&reportType=' +reportType, '_new');
        
    },
    
    funPrint: function(component, event){
        document.getElementById('prnBtn').style.display='none';  
        window.print();
        document.getElementById('prnBtn').style.display='block'; 
    }
    
})