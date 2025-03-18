({
	getCategories : function(component, treeId) {
        //Call apex method to populate cost category dropdown
        component.set('v.spinner', true);

        console.log('TreeId =' + treeId);
		var action = component.get("c.populateCostCategories");
        action.setParams({treeId : treeId});
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state == "SUCCESS")
           {
               console.log('===='+JSON.stringify(response.getReturnValue()));
               var result = response.getReturnValue();
               console.log('result ++++', result);
               var resultMap = result.descriptionMap;
               component.set("v.ESTFormat",result.estFormat);
               var catMap = [];
               for (var key in resultMap)
               {
                   catMap.push({key: key, value: resultMap[key]});
               }
               component.set("v.categories", catMap);
               component.set("v.selectedCat", null);
               component.set("v.fiscalYear", result.fiscalYear);
               component.set('v.spinner', false);

               //Call apex method to populate tree
               //this.updateTree(component, catMap[0].value.split('-')[1]);
           }
            
        });
        $A.enqueueAction(action);
	},
    
    updateTree : function(component, cat) {

        console.log('=='+component.get("v.ESTFormat"));
        var action = component.get("c.populateTree");
        component.set('v.spinner', true);

        action.setParams ({
            selectedCat : cat,
            ESTFormat:component.get("v.ESTFormat"),
            fiscalYear:component.get("v.fiscalYear")
                        });
        action.setCallback(this, function(response) {

            var items = response.getReturnValue();
            component.set("v.items", items);
            component.set("v.fullItems", items);
            component.set('v.spinner', false);

        });
        $A.enqueueAction(action);
        
    },
    
    checkParent : function(itemList, childList, masterList, currentItem, level)
    {
        console.log('HELPER');
        console.log(itemList);
        console.log(childList);
        
        if(itemList.length < 1 || 
           itemList[itemList.length-1].label != currentItem.label)
        {
            //console.log('First In List!');
            //console.log(itemList[itemList.length-1]);
            //console.log(currentItem.label);
            var t = {};
            t.label = currentItem.label;
            t.expanded = true;
            t.disabled = false;
            t.items = childList;
            
            itemList.push(t);
            if(level == '3')
                masterList.push(t);
        }
        //parent already in list
        else
        {
            //console.log('Already in list!');
            //console.log(itemList[itemList.length-1]);
            //console.log(childList);
            if(itemList[itemList.length-1].items == null)
                itemList[itemList.length-1].items = [];
            
            itemList[itemList.length-1].items = childList;  
        }
    }
    
})