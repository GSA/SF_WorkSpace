({
    getComparisonData : function(component, event, helper) {
        console.log('comparison data start');
        let projectData = component.get('v.selectedLookUpRecords');//event.getParam('value');
        var projIds = [];
        for(let i=0; i<projectData.length; i++){
            let p = projectData[i];
            projIds.push(p.Id);
        }

        if (projIds.length > 0){
            
            component.set('v.isLoaded', false);
            var costType = 'cost'; //TODO: Drop down select at top and param
            var reportType = component.get('v.reportType'); //'BasicCostOutput';
            var printMode = component.get('v.printMode');
            var costType = component.get('v.selectedCostType');

            let compData = component.get('c.getReportData');
            console.log('comparison data params', projIds, reportType, costType);
            compData.setParams({
                "projIds" : projIds,
                "reportType" : reportType,
                "reportMode" : "comparison",
                "costType" : costType
            });
            compData.setCallback(this, function(response){
                var state = response.getState();
                console.log('callback....' +state +' ' +component.isValid());
                console.log(response.getReturnValue());
                if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                    var reportData = response.getReturnValue();
                    //reportData.sections = JSON.parse(reportData.sectionJSON);
                    //reportData.sectionJSON = null;

                    var activeSections = [];
                    for (var i = 0; i < reportData.sections.length; i++){
                        if (i == 0 || printMode == 'true' || reportData.sections[i].defaultExpanded){
                            activeSections.push('' +i);
                        }
                        reportData.sections[i].name = '' +i;
                    }

                    component.set('v.activeSections', activeSections);
                    component.set('v.comparisonData', reportData);

                    
                    //this.displayData(component, event, helper);
                }else if(state==='INCOMPLETE'){
                    console.log(JSON.stringify(response.getError()));
                }else if(state ==='ERROR'){
                    console.log(response.getError());
                }else{
                    
                }
                component.set('v.isLoaded', true);
            });
    
            $A.enqueueAction(compData);
        }
     }
})