({
    init : function(component, event, helper) {
        console.log('init new cmp!');
        var treeId = component.get("v.recordId");
        console.log('FILENAME=' + component.get("v.fileName"));
        helper.getCategories(component, treeId);
    },
    
    updateTree: function(component, event, helper) {
        if(component.get("v.showDESList") == true)
        {
            component.set("v.body", '');
        }
        
        var selectedCat = component.find('cats').get('v.value');
        
        //Disable search if no Cost Category is selected
        if(selectedCat != "")
            component.set('v.unsearchable', false);
        else
            component.set('v.unsearchable', true);
        
        var cats = selectedCat.split('-');
        console.log('selectedCat', selectedCat);
        component.set('v.selectedCat', selectedCat);


        //get lookups for selected category. Pass unique level 3 lookups to tree. 
        let tempList = component.get('v.catList').filter(item => item.Lvl2Desc__c == selectedCat);
        let selectedCatList = [];
        for(let i=0; i<tempList.length; i++){
            let current = tempList[i];
            delete current['Id'];
            console.log('current', current);
            let previous =tempList[i-1];
            if(JSON.stringify(current) != JSON.stringify(previous)){ 
                selectedCatList.push(current)};
        }
        component.set('v.ESTFormat',selectedCatList[0].Level_2__r.Estimate_Format__c);
        component.set('v.selectedCategoryId', selectedCatList[0].Level_2__c);
        console.log('selectedCatList', selectedCatList);
        helper.updateTree(component, cats[1], selectedCatList);
        
    },
    
    handleSelect: function(component, event, helper) {
        var name = event.getParam('name');
        console.log('SELECTED: ' + name);
        
		if(name != 'N')
        {
            if(component.get("v.showDESList") == true)
            {
                component.set("v.body", '');
            }
            
            var levels = name.split('|');
            console.log(levels);
            
           // component.set('v.level5desc', levels[0]);
            component.set('v.level4desc', levels[0]);
            component.set('v.level3desc', levels[1]);
            component.set('v.level2desc', levels[2]);
            
            //Create DES Item list component
            
            var cat = component.get("v.selectedCat");
            cat = cat.split('-')[1];
            console.log('cat = ' + cat);
            
            $A.createComponent(
                "c:NCMT_AssembliesView_Items_LC",
                {"recordId" : component.get("v.recordId"),
                 "costCat" : cat,
                 "level4desc" : component.get("v.level4desc"),
                 "level3desc" : component.get("v.level3desc"),
                 "level2desc" : component.get("v.level2desc"),
                 "ESTFormat":component.get("v.ESTFormat"),
                  "categoryId": component.get('v.selectedCategoryId')}, 
                function(newcomponent) {
                    if(component.isValid())
                    {
						var body = component.get("v.body");
                        body.push(newcomponent);
                        component.set("v.body", body);
                        component.set("v.showDESList", true);
                    }   
                });
        }
        else
        {
            if(component.get("v.showDESList") == true)
            {
                console.log('destroy!');
                component.set("v.body", '');
            }
        }
            
    },
    
    search: function (component, event, helper) {
        var items = component.get("v.fullItems");
            var queryTerm = component.find('search').get('v.value');
            queryTerm = queryTerm.toLowerCase();
            //console.log('Searched for "' + queryTerm + '"!');
            console.log(items[0]);
        
        	if(queryTerm.length < 1) {
                console.log('empty!');
                component.set("v.items", items);
            }
        
            else {
            console.log('\nNEW');
                
        	var newItems = [];
            for(var x = 0; x < items.length; x++)
            {
                var level5items = [];
                var level4items = [];
                var level3items = [];
				//console.log('Level 3 ');
				
                                
                var items2 = items[x].items;
                level4items = [];
                
                if(items2 != null)
                {
                    for(var y = 0; y < items2.length; y++)
                    {
                       //console.log('Level 4');
                        
                       var items3 = items2[y].items;
                       level5items = [];
                        
                        if(items3 != null)
                        {
                            for(var z = 0; z < items3.length; z++)
                            {
                                //console.log('Level 5 ');
                                
                                //Level 5 contains search term
                                if(items3[z].label.toLowerCase().includes(queryTerm))
                                {
                                    console.log('Found in level 5! ' + items3[z].label);
                                    console.log(items3[z]);
                                    level5items.push(items3[z]);
                                    
                                    helper.checkParent(level4items, level5items, newItems, items2[y], '4');
                                    helper.checkParent(level3items, level4items, newItems, items[x], '3');
                                    
                                }
                                //Level 5 does not contain search term
                                else
                                {
                                    console.log('Search term not in Level 5');
                                    console.log(items2[y]);
                                    console.log(level3items);
                                    console.log(level4items);
                                    
                                    if(items2[y].label.toLowerCase().includes(queryTerm) )
                                    {
                                        if(level4items.includes(items2[y]) == false)
                                          level4items.push(items2[y]);
                                        
                                        //Level 3 parent not already in list
                                        helper.checkParent(level3items, level4items, newItems, items[x], '3');
                                    }
                                    
                                }
                             }
                        }
                        //Level 5 items is null
                        else
                        {
                            console.log('Level 5 null');
                            if(items2[y].label.toLowerCase().includes(queryTerm))
                            {
                                console.log('Level 4 with no Level 5!');
                                level4items.push(items2[y]);
                                
                            	//Level 3 parent not already in list
                            	helper.checkParent(level3items, level4items, newItems, items[x], '3');
                            }
                        }
                    }
                }
                //Level 4 items is null
                else
                {
                    if(items[x].label.toLowerCase().includes(queryTerm))
                    {
						console.log('Level 3 with no Level 4!');
                        level3items.push(items[x]);
                        newItems.push(items[x]);
                    }
                }
                
                newItems.push(level3items);
            }
        	component.set("v.items", newItems);
            }
    }
})