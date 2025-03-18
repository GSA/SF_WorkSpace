({
    getTreeData : function(component, event, helper) {
        component.set("v.body", '');
        var fiscalYear = component.get('v.fiscalYear');
        if (fiscalYear != null &&fiscalYear != ''){
            component.set('v.isLoaded', false);

            var parentKey = component.get('v.parentKey');
            //var searchVal = component.get('v.searchVal');
            var level = component.get('v.level');
            var compData = component.get('c.treeMe');
            var searchVal = component.get('v.searchVal');
            var fileType = component.get('v.fileType');
            console.log('about to pull tree data ' +fileType);

            var callback = event.getParam('callback');
            var params = {
                "level" : level,
                "parentKey" : parentKey,
                "fiscalYear" : fiscalYear,
                "searchVal" : searchVal,
                "fileType" : fileType
            };
            console.log(params);
            
            
            compData.setParams(params);
            compData.setCallback(this, function(response){
                var state = response.getState();
                console.log('callback....' +state +' ' +component.isValid());
                if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                    var treeData = response.getReturnValue();
                    
                    component.set('v.title', treeData.title);
                    
                    console.log(treeData);
                    component.set('v.branches', treeData.branches);

                    component.set('v.objectName', treeData.objectName);
                    
                    component.set('v.isLoaded', true);

                }else if(state==='INCOMPLETE'){
                    console.log(JSON.stringify(response.getError()));
                }else if(state ==='ERROR'){
                    console.log(JSON.stringify(response.getError()));
                    //console.log(response.getError());
                }else{
                    
                }
                
            });
    
            $A.enqueueAction(compData);
        }//end if project id
     },
     treeMe : function(treeData){
        component.set('v.branches', treeData.branches);
        console.log(treeData.branches);
        component.set('v.isLoaded', true);
     },

     showItems : function(component, cat, catId, level3, level4, level5, level6, estFormat){
         //console.log('showItems start ' +estFormat);
         if(component.get("v.showList") == true)
         {
             component.set("v.body", '');
         }
         
         var objectName = component.get("v.objectName");
         var fiscalYear = component.get("v.fiscalYear");

         if (objectName == 'NCMT_DES_Lookup_details__c'){
         
            //Create DES Item list component
             $A.createComponent(
                 "c:NCMT_TreeView_Items_LC",
                 {"recordId" : component.get("v.recordId"),
                  "costCat" : cat,
                  "level5desc" : level5,
                  "level4desc" : level4,
                  "level3desc" : level3,
                  "level2desc" : cat,
                  "ESTFormat": estFormat,
                  "projectYear": fiscalYear
                }, 
                 function(newcomponent) {
                     if(component.isValid())
                     {
                         var body = component.get("v.body");
 
                         body.push(newcomponent);
                         component.set("v.body", body);
                         component.set("v.showList", true);
                     }   
                 });
         } else if (estFormat == 'GSA Assemblies') {
            
            //Create Assembly Item list component
            $A.createComponent(
                "c:NCMT_GSAAssemblies_Items_LC",
                {"recordId" : component.get("v.recordId"),
                    "costCat" : cat,
                    "level2desc" : cat,
                    "level3desc" : level3,
                    "level4desc" : level4,
                    "level5desc" : level5,
                    "level6desc" : level6,
                    "ESTFormat": estFormat,
                 	"projectYear": fiscalYear
                    }, 
                function(newcomponent) {
                    if(component.isValid())
                    {
                        var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body);
                        component.set("v.showList", true);
                    }   
            });
         } else {
            console.log('assemblies other than Express: ' +catId);
            //Create Assembly Item list component
            $A.createComponent(
                "c:NCMT_AssembliesView_Items_LC",
                {"recordId" : component.get("v.recordId"),
                    "costCat" : cat,
                    "level2desc" : cat,
                    "level3desc" : level3,
                    "level4desc" : level4,
                    "level5desc" : level5,
                    "level6desc" : level6,
                    "ESTFormat": estFormat,
                    "categoryId" : catId,
	                 "projectYear" : fiscalYear
                    }, 
                function(newcomponent) {
                    if(component.isValid())
                    {
                        var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body);
                        component.set("v.showList", true);
                    }   
            });
         }
         window.scrollTo(0, 0);
     },

     loadYears : function(component, event, helper){
         var years = [];
         var d = new Date(2020,1,1);
         var current = new Date();
         console.log('d == ' +d +' current == ' +current);
         while (d.getFullYear() <= current.getFullYear()){
             years.push(d.getFullYear());
             d.setDate(d.getDate() + 365);
         }
         component.set('v.years', years);
     }
})