({
    fetchData : function(cmp) {
        var projectId = cmp.get('v.recordId');
        
        return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.init');
            init.setParams({
                'recordId' :cmp.get('v.recordId')
            });
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
        
    },
     setTreeData: function(cmp, trees, isPaste){
        console.log('trees',trees);
        let treeArr = [];
        let found;
        let expandedRows =[];

        for(let i=0; i<trees.length; i++){
            //add url for trees
            trees[i].linkName = '/'+trees[i].Id;
            
            //find parents for children
            if(trees[i].Level__c != 0){
                //set parent tree name (apparently tree grid can't handle related lists)
                //Added line 32 if condition for the story SFWS-1819
                if(trees[i].Relatedtree__c){
                trees[i].parentName = trees[i].Relatedtree__r.Name;
                }
                 //find parent of current tree
                found = trees.find(parent=> parent.Id == trees[i].Relatedtree__c);
                //Added line 38 if condition for the story SFWS-1819
                if(found!=undefined){
                //if parent has children, create child array
                if(!found['_children']){found._children = []};
                
                //if on reports page, expand all trees.
                if(cmp.get('v.isReports'))expandedRows.push(trees[i].Name);
                //add current tree to parent array
                found['_children'].push(trees[i]);
                }
            }
        }
        //add top level tree containing all children to new array
        treeArr.push(trees[0]);
        expandedRows.push(treeArr[0].Id);
        console.log(treeArr);
             
		if(!isPaste)
        	cmp.set('v.treeLevels', treeArr);
         else 
            cmp.set('v.pasteLevels', treeArr);
         
        cmp.set('v.gridExpandedRows', expandedRows);
    },
    
    getTreeCopies: function(cmp, selected) {
        var action = cmp.get('c.copyTrees');
        action.setParams({ trees : selected});
        
        action.setCallback(this, function(res) {
           var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('SUCCESS!');
                var cpy = res.getReturnValue();
                console.log(cpy);
                
                cmp.set('v.treeCopy', cpy);
            }
            else
                console.log('NO SUCCESS!');
        });
        
        $A.enqueueAction(action);
    },
    
    getPasteTree: function(cmp)
    {
        return new Promise($A.getCallback(function(resolve, reject){
            let action = cmp.get('c.getTreeData');
            action.setParams({ 'projectId' : cmp.get('v.recordId'),
                         	   'isPaste' : true});
            action.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(action);
        }));
                           
                           
    },
    
    pasteCopies: function(cmp, copies, parent)
    {
        console.log('helper');
        //console.log(copies);
        
        var action = cmp.get('c.pasteTrees');
        action.setParams({ "copies" : copies,
                           "parent" : parent,
                           "projId" : cmp.get('v.recordId')
                         });
        
        action.setCallback(this, function(res) {
           var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('SUCCESS!');
                $A.get('e.force:refreshView').fire();
            }
            else
                console.log('NO SUCCESS!');
        });
        
        $A.enqueueAction(action);
    },
    
    deleteTrees : function(cmp, toDelete) {
        console.log('helper');
        console.log(toDelete);
        
        var action = cmp.get('c.deleteTrees');
        action.setParams({ "toDelete" : toDelete
                         });
        
        action.setCallback(this, function(res) {
            var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('SUCCESS!');
                $A.get('e.force:refreshView').fire();
            }
            else {
                console.log('NO SUCCESS!');
                console.log(res.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    
    getChildIds : function(cmp, children, childDelete) {
        console.log('get child ids', children);
        //var childDelete = [];
        for(var i=0;i<children.length;i++)
        {
            //console.log(children[i].Id);
            childDelete.push(children[i].Id);
            if(children[i]._children) {
            	//console.log(children[i]._children);
                this.getChildIds(cmp, children[i]._children, childDelete);
            }
        }
        //console.log('childDelete', childDelete);
        return childDelete;
    }

    
})