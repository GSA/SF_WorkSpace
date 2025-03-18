({
    init : function(component, event, helper) {
        
        var y = component.get('v.fiscalYear');
        console.log('year.... ' +y);
        helper.getTreeData(component, event, helper);
        
        var projId = component.get('v.projectId');
        if (projId == null || projId == '') helper.loadYears(component, event, helper);
    },

    clear : function(component, event, helper){
        component.set('v.searchVal', null);
        helper.getTreeData(component, event, helper);
    },

    sendBranchClick : function(component, event, helper){ //branchEvent
        
        var level = component.get('v.level').valueOf();
        
        console.log('sendBranchClick start ' +level);

        var ctarget = event.currentTarget;
        var catS = ctarget.dataset.cat;  
        var catId = ctarget.dataset.catid; 
        var estFormat = ctarget.dataset.estformat;
        console.log('sendBranchClick catId === ' +catId);
        var showItems = (ctarget.dataset.showitems == 'true');  
        
        var level3;
        var level4;
        var level5;
        var level6;
        if (level > 1){
            level3 = ctarget.dataset.level3;
            if (level > 2){
                level4 = ctarget.dataset.level4;
                if (level > 3){
                    level5 = ctarget.dataset.level5;
                    if (level > 4){
                        level6 = ctarget.dataset.level6;
                    }
                }
            }
        }   
        var uniqueId = ctarget.dataset.unique;
        

        var elems = document.getElementsByClassName('branchSelected');
        for (var i = 0; i < elems.length; i++) {
            elems[i].classList.remove('branchSelected');
        }

        document.getElementById(uniqueId +'-' +level +'-block').classList.add('branchSelected');
        
        console.log('sendBranchClick params: level = ' +level, catS, level3, level4, level5, level6, showItems, estFormat);
        //What level is this? Only level 1 displays the items
        if (showItems){
            if (level == 1){
                helper.showItems(component, catS, catId, level3, level4, level5, level6, estFormat);
            } else {
                var passBranchUp = component.getEvent("branchClick");

                passBranchUp.setParams({
                    cat : catS,
                    catId : catId,
                    level3 : level3,
                    level4 : level4,
                    level5 : level5,
                    level6 : level6,
                    fromLevel : level,
                    showItems : showItems,
                    estFormat : estFormat
                });
                console.log('passBranchUp send', passBranchUp);
                passBranchUp.fire();
            }
        }
    },

    handleBranchClick : function(component, event, helper){ //branchEvent

        console.log('handleBranchClick start');
        var catS = event.getParam('cat');
        var catId = event.getParam('catId');
        var level3S = event.getParam("level3");
        var level4S = event.getParam("level4");
        var level5S = event.getParam("level5");
        var level6S = event.getParam("level6");
        var showItems = event.getParam("showItems");
        var estFormat = event.getParam("estFormat");
        //var fromLevel = event.getParam("fromLevel");
        var level = component.get('v.level');
       

        console.log('handleBranchClick params: level = ' +level, catS, level3S, level4S, level5S, level6S, showItems);
        
        if (showItems){
            //What level is this? Only level 1 displays the items
            if (level == 1){
                //helper.getBranchItems(catS, level3S, level4S, level5S);
                helper.showItems(component, catS, catId, level3S, level4S, level5S, level6S, estFormat);
            
            } else {
                var passBranchUp = component.getEvent("branchClick");

                passBranchUp.setParams({
                    cat : catS,
                    catId : catId,
                    level3 : level3S,
                    level4 : level4S,
                    level5 : level5S,
                    level6 : level6S,
                    fromLevel : level,
                    showItems : showItems,
                    estFormat : estFormat
                });
                console.log('passBranchUp handle', passBranchUp);
                passBranchUp.fire();
            }
        }
    },
    
    toggleBranch : function(component, event, helper){
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;

        //Clear the selected branch
        var elems = document.getElementsByClassName('branchSelected');
        for (var i = 0; i < elems.length; i++) {
            elems[i].classList.remove('branchSelected');
        }
        if(component.get("v.showList") == true || component.get("v.showList") == true)
         {
             component.set("v.body", '');
         }
        
        var branches = component.get('v.branches');
        var branchDivId;
        var level = component.get("v.level");
        var wasOpen = false;
        for (var i = 0; i < branches.length; i++){
           
            if (branches[i].parentKey == id_str){
                wasOpen = branches[i].branchesExpanded;
                branches[i].branchesExpanded = !branches[i].branchesExpanded;
                branchDivId = branches[i].uniqueKey +'-' +level +'-block';
            }
        }
        //console.log(branches);
        component.set('v.branches', branches);

        //Scroll to branch just toggled (expand/collapse confusing without this)
        if (wasOpen){
            var branchDiv = document.getElementById(branchDivId);
            window.scrollTo(0, branchDiv.getBoundingClientRect().top);
        }
    }
})