({
    init : function(component, event, helper) {
        console.log('init new cmp!');
        var treeId = component.get("v.recordId");
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

        helper.updateTree(component, cats[1]);
        
    },
    
    handleSelect: function(component, event, helper) {
        component.set('v.spinner', true);
        console.log( 'spin is true', component.get('v.spinner'))

        var name = event.getParam('name');
        console.log('SELECTED: ' + name);
        
		if(name != 'N')
        {
            if(component.get("v.showDESList") == true)
            {
                component.set("v.body", '');

            }
            
            var levels = name.split('|');
            
            component.set('v.level5desc', levels[0]);
            component.set('v.level4desc', levels[1]);
            component.set('v.level3desc', levels[2]);
            component.set('v.level2desc', levels[3]);

            //Create DES Item list component
            
            var cat = component.get("v.selectedCat");
            cat = cat.split('-')[1];
            $A.createComponent(
                "c:NCMT_TreeView_Items_LC",
                {"recordId" : component.get("v.recordId"),
                 "costCat" : cat,
                 "level5desc" : component.get("v.level5desc"),
                 "level4desc" : component.get("v.level4desc"),
                 "level3desc" : component.get("v.level3desc"),
                 "level2desc" : component.get("v.level2desc"),
                 "ESTFormat":component.get("v.ESTFormat")}, 
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
        component.set('v.spinner', false);

    },
    
        search: function (component, event, helper) {
        var items = component.get("v.fullItems");
            var queryTerm = component.find('search').get('v.value');
            console.log('Searched for "' + queryTerm + '"!');
            queryTerm = queryTerm.toLowerCase();
            
            //console.log('NEW');
            
            if(queryTerm.length < 1) {
                console.log('empty!');
                component.set("v.items", items);
            }
        
            else {
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
                                if(items3[z].label.toLowerCase().includes(queryTerm) )
                                {
                                    //console.log('Found in level 5! ' + items3[z].label);
                                    level5items.push(items3[z]);
                                    
                                    helper.checkParent(level4items, level5items, newItems, items2[y], '4');
                                    helper.checkParent(level3items, level4items, newItems, items[x], '3');
                                    
                                }
                                //Level 5 does not contain search term
                                else
                                {
                                    //console.log('Search term not in Level 5');
                                    
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
                            if(items2[y].label.toLowerCase().includes(queryTerm))
                            {
                                //console.log('Level 4 with no Level 5!');
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
						//console.log('Level 3 with no Level 4!');
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