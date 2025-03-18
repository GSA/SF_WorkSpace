({
    fetchData : function(cmp) {
        
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
    
    fetchDeliverables : function(cmp) {
        
        return new Promise($A.getCallback(function(resolve, reject){
            var action = cmp.get('c.getDeliverables');
           
            action.setParams({
                'filterDel' : cmp.get('v.filterDeliverable')
            });
            action.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(action);
            
        }));
        
    }
})