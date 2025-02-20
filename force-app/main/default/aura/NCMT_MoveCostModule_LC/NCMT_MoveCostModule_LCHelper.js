({
    createProj : function(cmp, projName) {
        
        return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.createProject');
            init.setParams({
                projName : projName
            });
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
    },
    
    fetchData : function(cmp) {
        console.log('fetch data!');
        
        return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.initMoveCostMod');
            /*init.setParams({
                projName : projName
            });*/
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
    },
    
    setData : function(cmp, items, costs) {
        console.log('helper', items);
        console.log('costs', costs);
        for(var i=0;i<items.length;i++)
        {
            var otherCostSum = 0;
            
            //Set NCMT Project URL link and change NCMT_Housing_Plans__r to _children for treeGrid
            items[i].linkName = '/'+items[i].Id;
            items[i]._children = items[i]['NCMT_Housing_Plans__r'];
            delete items[i].NCMT_Housing_Plans__r;
            items[i].isProj = true;
            
            //Set Housing Plan URL link and calculate Other Cost totals for each Housing Plan
            if(items[i]._children != undefined)
            {
                for(var x=0;x<items[i]._children.length;x++)
                {
                    var otherCostHPSum = 0;
                    items[i]._children[x].linkName = '/'+items[i]._children[x].Id;
                    items[i]._children[x].isProj = false;
                    if(items[i].Other_Costs__r != undefined)
                    {
                        for(var y=0;y<costs.length;y++)
                        {
                            if(costs[y].NCMT_Housing_Plan_Option_Selection__r.NCMT_Housing_Plan__c ===
                               items[i]._children[x].Id)
                                otherCostHPSum += costs[y].Total1__c; 
                        }  
                    }
                    items[i]._children[x].Other_Costs_Total = otherCostHPSum;
                }
            }
            else
                items[i]._children = [{Name: 'No Housing Plans'}];
            
            //Get Sum of Other Costs for entire Project
            if(items[i].Other_Costs__r != undefined)
            {
                
                for(var y=0;y<items[i].Other_Costs__r.length;y++)
                {
                    otherCostSum += items[i].Other_Costs__r[y].Total1__c;
                }
            }
            
            items[i].Other_Costs_Total = otherCostSum;
        }
        
        cmp.set('v.data', items);
    },
    
    getRowActions : function(cmp, row, cb) {
        var actions = [];
        
        if(row.isProj == true)
        {
            actions = [{ label: 'Add Housing Plan', name: 'add' },
                       { label: 'Manage Moving Costs', name: 'manageMC' },
                       { label: 'Project Moving Costs Report', name: 'report'}
                      ];
        }
        else
        {
            actions = [{label: 'View Housing Plan', name: 'view'},
                       {label: 'Edit Housing Plan', name: 'edit'}];
        }
        cb(actions);
        
        
    },
    //Code added for Project Moving Cost report Block#1
    postRedirect: function(cmp, evt, hlp,reportId,projName){
        var isLightning = cmp.get("v.isLightning");
        console.log("Lightning Status",isLightning);
        if(isLightning==false){
            parent.window.location = "/" + reportId + "?pv0=" + escape(projName);
            console.log("I'm classic");
        }
        else{
            console.log("I'm lightning");
            
            window.location.href="/lightning/r/Report/"+ reportId + "/view?fv0="+escape(projName);       
        }
    },   
    //End of code
    
    //Code added for Add Housing Plan Block#1
    postMoveRedirect: function(cmp, evt, hlp,projName,projId,projURL,mcmURL){
        var isLightning = cmp.get("v.isLightning");
        console.log("Lightning Status",isLightning);
        if(isLightning==false){
            window.location.href = '/a1C/e?'+projURL+'='+projName+'&'+mcmURL+'=1&nooverride=1';
            console.log("I'm classic");
        }
        else{          
            window.location.href = '/lightning/o/NCMT_Housing_Plan__c/new?defaultFieldValues=Project__c='+projId+',Move_Cost_Module__c=true&nooverride=1';  
            console.log("I'm lightning"); 
        }
    }
    //End of code    
})