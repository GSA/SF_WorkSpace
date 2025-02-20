({
	fetchData : function(cmp) {
        var projectId = cmp.get('v.recordId');
        console.log('@@'+cmp.get('v.recordId'));
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
    setData: function(cmp, projectMP){
        cmp.set('v.mpdata', projectMP);
        console.log(projectMP);
        for(let i=0; i<projectMP.length; i++){
            //add url
            projectMP[i].linkName = '/'+projectMP[i].Id;
        }
        cmp.set("v.loadingComplete",true);
    }
})