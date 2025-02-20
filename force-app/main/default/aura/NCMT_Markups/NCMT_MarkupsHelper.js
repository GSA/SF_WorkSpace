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
})