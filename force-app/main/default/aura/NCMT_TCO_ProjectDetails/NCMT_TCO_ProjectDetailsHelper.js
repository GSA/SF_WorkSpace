({
    
    getReportData : function(component, event, helper) {
        var projId = component.get('v.id');
        if (projId != null &&projId != ''){
            //Storing in an array because controller uses the same logic as the comparison reports
            var projIds = [];
            projIds.push(projId);
            

            var rowSpecs = [];
            var costType = 'cost'; //TODO: Drop down select at top and param
            var reportType = component.get('v.reportType'); //'BasicCostOutput';
            var printMode = component.get('v.printMode');
            var costType = component.get('v.selectedCostType');
            let compData = component.get('c.getReportData');

            compData.setParams({
                "projIds" : projIds,
                "reportType" : reportType,
                "reportMode" : "details",
                "costType" : costType
            });
            compData.setCallback(this, function(response){
                var state = response.getState();
                console.log('callback....' +state +' ' +component.isValid());
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
                    component.set('v.reportData', reportData);
                    console.log(reportData);

                }else if(state==='INCOMPLETE'){
                    console.log(JSON.stringify(response.getError()));
                }else if(state ==='ERROR'){
                    console.log(response.getError());
                }else{
                    
                }
                component.set('v.isLoaded', true);
            });
    
            $A.enqueueAction(compData);
        }//end if project id
     }
})