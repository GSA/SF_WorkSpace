({
    getProjectData : function(component, event, helper) {
        
        let projData = component.get('c.projectData');
        var recordId = component.get('v.recordId');
        projData.setParams({
             "projId" : recordId
         });
         projData.setCallback(this, function(response){
             var state = response.getState();
             console.log('callback....' +state +' ' +component.isValid());
             if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                 component.set('v.project', response.getReturnValue());
                 this.displayData(component, event, helper);
             }else if(state==='INCOMPLETE'){
                 console.log(JSON.stringify(response.getError()));
             }else if(state ==='ERROR'){
                 console.log(response.getError());
             }else{
                 
             }
         });
 
         $A.enqueueAction(projData);
     },

     displayData : function(component, event, helper) {
        component.set('v.isLoaded', false);

        var columns = [{label: ' ', fieldName: 'year', type: 'number', initialWidth: 50, hideDefaultActions: true}, 
                        {label: 'fy', fieldName: 'fy', type: 'string', initialWidth: 80, hideDefaultActions: true}];
        
        var data = [];
        var proj = component.get('v.project');
        var isInit = component.get('v.isInit');
        var categories = [{label: 'All', value: 'all'}];
        var costDetails = [{label: 'All', value: 'all'}];

        var grouping = unescape(component.get('v.selectedGrouping'));
        var costType = unescape(component.get('v.selectedCostType'));
        var selectedCategory = unescape(component.get('v.selectedCategory'));
        var previousCategory = unescape(component.get('v.previousCategory'));
        var selectedCostDetail = unescape(component.get('v.selectedCostDetail'));
        
        var totalRow = {year: null, fy: 'Totals'};
        for (var i = 0; i < proj.lccs.length; i++){
            
            var lcc = proj.lccs[i];
            
            var row = {year: lcc.record.Year__c, fy: lcc.stringYear};
            
            //console.log(lcc);
            for (var c = 0; c < lcc.categories.length; c++){
                
                var cat = lcc.categories[c];
                if (selectedCategory == 'all' || selectedCategory == cat.name){
                    //First row, load up the columns and if this is the page load, the catgories
                    if (i == 0 ){
                        if (isInit){
                            categories.push({label: cat.name, value: cat.name});
                        }
                        //init
                        if (grouping == 'category'){
                            columns.push({label: cat.name, fieldName: cat.name, type: 'currency', initialWidth: 150, hideDefaultActions: true,
                                          typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 0, minimumFractionDigits: 0}, hideDefaultActions: true});
                            totalRow[cat.name] = 0; 
                        }
                    } 
                    
                    //
                    if (grouping == 'category'){
                        row[cat.name] = cat[costType]; 
                        totalRow[cat.name] = totalRow[cat.name] + cat[costType];
                    }
                    if (isInit || grouping == 'cost'){
                        for (var co = 0; co < cat.costs.length; co++){
                            var cost = cat.costs[co];
                            if (i == 0){
                                
                                costDetails.push({label: cost.label, value: cost.label});
                                
                                if (grouping == 'cost' &&(selectedCostDetail == 'all' || selectedCostDetail == cost.label)){
                                    columns.push({label: cost.label, fieldName: cost.label, type: 'currency', initialWidth: 150, hideDefaultActions: true,
                                                  typeAttributes: { currencyDisplayAs : 'symbol', currencyCode: 'USD', maximumFractionDigits: 0, minimumFractionDigits: 0}, hideDefaultActions: true});
                                    totalRow[cost.label] = 0;
                                }
                            }
                            
                            if (grouping == 'cost' &&(selectedCostDetail == 'all' || selectedCostDetail == cost.label)){
                                row[cost.label] = cost[costType]; 
                                totalRow[cost.label] = totalRow[cost.label] + cost[costType]; 
                            }
                        }
                    }
            }
                //console.log('column load done, row is', row);
            }//end categories loop
            data.push(row);
        }
        data.unshift(totalRow);
        
        //console.log(columns);
        if (isInit){
            component.set('v.categories', categories);
            
        }
        if (previousCategory != selectedCategory){
            component.set('v.costDetails', costDetails);
            component.set('v.selectedCostDetail', 'all');
        }
        component.set('v.previousCategory', selectedCategory);

        component.set('v.columns', columns);
        component.set('v.data', data);
        component.set('v.isInit', false);
        component.set('v.isLoaded', true);
        
        
     }
})