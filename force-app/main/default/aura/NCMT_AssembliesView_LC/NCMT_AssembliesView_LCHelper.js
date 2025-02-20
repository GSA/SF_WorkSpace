({
	getCategories : function(component, treeId) {
        //Call apex method to populate cost category dropdown
        console.log('TreeId =' + treeId);
		var action = component.get("c.populateCostCategories");
        action.setParams({
            treeId : treeId,
            fileName: component.get("v.fileName")
            });
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state == "SUCCESS")
           {
               console.log('===='+JSON.stringify(response.getReturnValue()));
               var result = response.getReturnValue();
               var resultMap = result.descriptionMap;
               var catMap = [];
               for (var key in resultMap)
               {
                   catMap.push({key: key, value: resultMap[key]});
               }
               component.set("v.categories", catMap);
               component.set("v.selectedCat", null);
               component.set("v.fiscalYear", result.fiscalYear);
               component.set('v.catList', result.assembList);
               //Call apex method to populate tree
               //this.updateTree(component, catMap[0].value.split('-')[1]);
           }
            
        });
        $A.enqueueAction(action);
	},
    
    updateTree : function(component, cat, selectedCatList) {
        // console.log('=='+component.get("v.ESTFormat"));
        console.log('cat = ' + cat);
        var fiscalYear = component.get("v.fiscalYear");
        var action = component.get("c.populateTree");
        action.setParams ({ tempDetails : selectedCatList });
                       
        action.setCallback(this, function(response) {
            var items = response.getReturnValue();
            component.set("v.items", items);
            component.set("v.fullItems", items);
        });
        $A.enqueueAction(action);
        
    },
    
    checkParent : function(itemList, childList, masterList, currentItem, level)
    {
        
        if(itemList.length < 1 || 
           itemList[itemList.length-1].label != currentItem.label)
        {
            var t = {};
            t.label = currentItem.label;
            t.expanded = true;
            t.disabled = false;
            t.items = childList;
            
            console.log(t);
            
            itemList.push(t);
            if(level == '3')
                masterList.push(t);
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