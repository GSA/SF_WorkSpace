({
    init : function(cmp, evt, hlp) {
        //Default values if not passed in from url parameters
        if (cmp.get('v.selectedCostType') == null || component.get('v.selectedCostType') == '')
            cmp.set('v.selectedCostType', 'cost');

        cmp.set('v.displayCostType', cmp.get('v.selectedCostType'));
        if (cmp.get('v.selectedCostType') == 'cost')
            cmp.set('v.displayCostType', 'Constant Dollar');
        
        if (cmp.get('v.selectedCostType') == 'escalatedCost')
            cmp.set('v.displayCostType', 'Escalated Cost');
        if (cmp.get('v.selectedCostType') == 'escalatedDiscountedCost')
            cmp.set('v.displayCostType', 'Escalated &amp; Discounted Cost');

        cmp.set('v.reportType', 'BasicInputs');
        if (cmp.get('v.urlReportType') != null &&cmp.get('v.urlReportType') != '')
                cmp.set('v.reportType', unescape(cmp.get('v.reportType')));
                
        var urlProjs = [];
        if (cmp.get('v.project1') != null &&cmp.get('v.project1') != '')
            urlProjs.push( {Id: unescape(cmp.get('v.project1')), Name: unescape(cmp.get('v.project1Name'))} );
        if (cmp.get('v.project2') != null &&cmp.get('v.project2') != '')
            urlProjs.push( {Id: unescape(cmp.get('v.project2')), Name: unescape(cmp.get('v.project2Name'))} );
        if (cmp.get('v.project3') != null &&cmp.get('v.project3') != '')
            urlProjs.push( {Id: unescape(cmp.get('v.project3')), Name: unescape(cmp.get('v.project3Name'))} );
        if (cmp.get('v.project4') != null &&cmp.get('v.project4') != '')
            urlProjs.push( {Id: unescape(cmp.get('v.project4')), Name: unescape(cmp.get('v.project4Name'))} );
        if (cmp.get('v.project5') != null &&cmp.get('v.project5') != '')
            urlProjs.push( {Id: unescape(cmp.get('v.project5')), Name: unescape(cmp.get('v.project5Name'))} );
        //console.log(urlProjs);
        cmp.set('v.selectedLookUpRecords', urlProjs);
    },

    reportChange :function(cmp, evt, hlp){
        
        hlp.getComparisonData(cmp, evt, hlp);
    },
    onRender: function(cmp, evt, hlp){
        var reportData = cmp.get('v.comparisonData');
        
        if (reportData != null){
            for (var i = 0; i < reportData.sections.length; i++){
                //console.log(reportData.sections[i]);
                for (var r = 0; r < reportData.sections[i].rows.length; r++){
                    for (var q = 0; q < reportData.sections[i].rows[r].charts.length; q++){
                        var chartDef = reportData.sections[i].rows[r].charts[q];
                        var uniqueId = reportData.sections[i].rows[r].charts[q].uniqueId;
                        
                       
                        chartDef.options.tooltips = {callbacks: {
                            label: function(tooltipItem, data) {
                                return tooltipItem.yLabel.toLocaleString("en-US",{style:"currency", currency:"USD"});
                            }}
                        };
                        //Currency formatting
                        Chart.scaleService.updateScaleDefaults('linear', {
                            ticks: {
                                callback: function (value, index, values) {
                                    return value.toLocaleString("en-US",{style:"currency", currency:"USD"});
                                }
                            }
                        });
                        var chartCanvas = document.getElementById(uniqueId); 
                        //console.log(chartCanvas, chartDef);
                        var auraChart = new Chart(chartCanvas, chartDef);
                    }
                }
            }
        }
    },
    printMe: function(cmp){
        var costType = encodeURI(cmp.get('v.selectedCostType'));
        var reportType = encodeURI(cmp.get('v.reportType'));
        
        var reportLink = 'apex/NCMT_TCO_ProjectComparison?print=true&reportType=' +reportType +
            '&costType=' +costType ;

        for(let i=0; i<projectData.length; i++){
            let p = projectData[i];
            reportLink += 'project' +(i+1) +'=' +p.Id;
        }
        window.open(reportLink, '_new');
        
    },
    
    funPrint: function(component, event){
        document.getElementById('prnBtn').style.display='none';  
        window.print();
        document.getElementById('prnBtn').style.display='block'; 
    }
})