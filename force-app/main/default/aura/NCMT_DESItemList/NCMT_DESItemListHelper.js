({
	fetchData : function(cmp) {
		
        return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.getDESItemData');
            init.setParams({
                'treeId' :cmp.get('v.recordId')
            });
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
	},
    
    setData : function(cmp, items) {
        console.log(items);
        for(let i=0; i<items.length; i++){
            //add url
            items[i].linkName = '/'+items[i].Id;
            if(items[i].NCMT_Contractor_ID__c != null){
                items[i].subName = items[i].NCMT_Contractor_ID__r.Name;
                items[i].subLink = '/'+items[i].NCMT_Contractor_ID__c;
            }
        }
        
        cmp.set('v.data', items);
    },
    
    getDESCopies : function(cmp, selected) {
        console.log('helper');
        var action = cmp.get('c.copyDESItems');
        action.setParams({ items : selected});
        
        action.setCallback(this, function(res) {
           var state = res.getState();
            if(state === 'SUCCESS')
            {
                console.log('SUCCESS!');
                var cpy = res.getReturnValue();
                
                console.log(cpy);
                
                cmp.set('v.desCopy', cpy);
                cmp.set('v.hasCopy', true);
            }
            else
                console.log('NO SUCCESS!');
            
        });
        
        $A.enqueueAction(action);
    },
    
    pasteCopies : function(cmp, copies) {
        console.log('helper');
        //console.log(copies);
        
        var action = cmp.get('c.pasteDESItems');
        action.setParams({ "copies" : copies,
                          "treeId" : cmp.get('v.recordId'),
                           "projId" : cmp.get('v.projectId'),
                          "locationMultiplier" : cmp.get('v.locationMultiplier')
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
            console.log(res.getError());
        });
        
        $A.enqueueAction(action);
    },
    
    deleteItems : function(cmp, toDelete) {
        console.log(toDelete);
        
        var action = cmp.get('c.deleteDESItems');
        action.setParams({ "toDelete" : toDelete
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
    }
    
})