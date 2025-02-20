({
    getCategories : function(component, treeId) {
        //Call apex method to populate cost category dropdown
        console.log('TreeId =' + treeId);
		var action = component.get("c.populateCostCategories");
        action.setParams({treeId : treeId});
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state == "SUCCESS")
           {
               console.log('===='+JSON.stringify(response.getReturnValue()));
               var result = response.getReturnValue();
               var resultMap = result.descriptionMap;
               component.set("v.ESTFormat",result.estFormat);
               var catMap = [];
               for (var key in resultMap)
               {
                   catMap.push({key: key, value: resultMap[key]});
               }
               component.set("v.categories", catMap);
               //component.set("v.selectedCat", catMap[0].value);
               component.set("v.selectedCat", null);
               console.log( catMap[0], 'cat maps');
               component.set("v.fiscalYear", result.fiscalYear);
               
               //Call apex method to populate tree
               //this.updateTree(component, catMap[0].value.split('-')[1]);
           }
            
        });
        $A.enqueueAction(action);
	},
    
    
	updateTree : function(component, selectedCat) {
		var action = component.get("c.populateTree");
        var fiscalYear = component.get("v.fiscalYear");
        action.setParams({selectedCat : selectedCat,
                          fiscalYear: fiscalYear,
                          fileName : "GSAAssemblies"});
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state == "SUCCESS")
           {
               var items = response.getReturnValue();
               component.set("v.items", items);
               component.set("v.fullItems", items);
           }
            
        });
        $A.enqueueAction(action);
	},
    
        checkParent : function(itemList, childList, masterList, currentItem, level)
    {
        console.log('HELPER!');
            console.log(itemList);
            console.log(childList);
        if(itemList.length < 1 || 
           itemList[itemList.length-1].label != currentItem.label)
        {
            var t = {};
            t.label = currentItem.label;
            t.expanded = true;
            t.disabled = false;
            t.items = childList;
            
            itemList.push(t);
            if(level == '3')
            {
                t.name = currentItem.name;
                masterList.push(t);
            }
        }
        //parent already in list
        else
        {
            if(itemList[itemList.length-1].items == null)
                itemList[itemList.length-1].items = [];
            
            itemList[itemList.length-1].items = childList;  
        }
    }
})