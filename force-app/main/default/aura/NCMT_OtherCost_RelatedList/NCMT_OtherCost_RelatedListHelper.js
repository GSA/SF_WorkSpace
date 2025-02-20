({
	fetchData : function(cmp) {
		return new Promise($A.getCallback(function(resolve, reject){
            let init = cmp.get('c.getOtherCostData');
            init.setParams({
                //'projId' :cmp.get('v.projectId')
                recId : cmp.get('v.recordId')
            });
            init.setCallback(this, function(res){
                resolve(res.getReturnValue());
            });
            $A.enqueueAction(init);
            
        }));
	},
    
    setData : function(cmp, items, hpID) {
        console.log(items);
        
        //Set URL for Other Costs
        for(var i=0; i<items.length; i++)
        {
			items[i].linkName = '/'+ items[i].Id;
            cmp.set('v.projectId', items[i].NCMT_Project__c);
        }
        
        cmp.set('v.data', items);
    }
})