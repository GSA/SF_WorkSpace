({
    fetchPBSLeaseAccess : function(component,event,heper) {
		var action = component.get("c.getPBSLeaseAccessRecords");
        action.setParams({'leaseNumber' : component.get("v.leaseNumber")});
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	var results = response.getReturnValue();
	            component.set("v.LeaseAccessRecords", results);
                console.log('******wrapper',results);
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error loading cases: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error loading cases.");
                }
	        }
	    });
	    $A.enqueueAction(action);
    },
    
    revokeLeaseAccessHelper : function(component,event,leaseIds){
       if(confirm('Are you sure, you want to revoke access for the selected users?')){
  			var action = component.get('c.revokePBSLeaseAccess');
            action.setParams({"leaseAccessIds": leaseIds});
  			action.setCallback(this, function(response) {
   				var state = response.getState();
   				if (state === "SUCCESS") {
    				console.log(state);
                    console.log('******response',response.getReturnValue());
     				 var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                        "type" : "success",
                        "message": "The access for the selected users have been revoked!"
                     });
            		 toastEvent.fire();
    			}else if(state ==="ERROR"){
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                        "type" : "error",
                         "message": "Failed to delete the selected records due to following error:"+response.getReturnValue()
                     });
            		 toastEvent.fire();
                }
                component.set("v.selectedCount",0);    			
                this.fetchPBSLeaseAccess(component,event);
                
                               
  			});
  			$A.enqueueAction(action);
        }else{
           console.log('do not delete');
        }
        
    }
})