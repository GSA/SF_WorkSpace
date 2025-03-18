({
	loadPendingApprovalLeases: function(component) {
	    var action = component.get("c.getLsacWrapperList");
	    console.log('LeaseAccessApproval Component **'+component.get("v.statusFilters"));
	    action.setParams({'statusFilters' : component.get("v.statusFilters"),
	    				  'selectedPage' : component.get("v.selectedPage"),
	    				  'pageSize' : component.get("v.pageSize") });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	console.log(response.getReturnValue());
	        	var lsacListWrapper = response.getReturnValue();
	            component.set("v.leaseAccessList", lsacListWrapper.leaseAccessList);
	            component.set("v.resultsHaveNext", lsacListWrapper.hasNext);
	            component.set("v.resultsHavePrev", lsacListWrapper.hasPrevious);
	            component.set("v.totalLsAcs", lsacListWrapper.totalLsAcs);
	            component.set("v.totalPages", lsacListWrapper.totalPages);
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error loading lease access records: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error loading lease access records.");
                }
	        }
	    });
	    $A.enqueueAction(action);
	},
    
    showApproveRejectPopup: function(component, event) {
    	var selectedLsac = event.currentTarget;
		var lsacId = selectedLsac.dataset.lsacid;
		var leaseAccessList = component.get("v.leaseAccessList");
		var lsac;

		for(var i = 0; i < leaseAccessList.length; i++) {
			lsac = leaseAccessList[i];
			if(lsacId == lsac.Id) {
				component.set("v.selectedLsac", lsac);
				break;
			}
		}
		document.getElementById('access-approve-reject').style.display = 'block';
    
	},
    cancelApproveReject: function(component) {
		document.getElementById('access-approve-reject').style.display = 'none';
    },
    approveAccess: function(component) {
		var action = component.get("c.ApproveLeaseAccess");
		action.setParams({ "lsac" : component.get("v.selectedLsac") });
        
        action.setCallback(this, function(response) {
            document.getElementById('access-approve-reject').style.display = 'none';
            var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
                console.log('approveAccess response *** '+response.getReturnValue());
	        	var result = response.getReturnValue();
                if(result === true) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": $A.get("$Label.c.RET_Lease_Access_Request_Approved_Success"),
                        "type": "success",
                        "duration": "10000"
                    });
                    toastEvent.fire();
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message,
                        "type": "error",
                        "duration":"10000"
                    });
                    toastEvent.fire();
                }
            }
            this.loadPendingApprovalLeases(component);
        });
	    $A.enqueueAction(action);
    },
    rejectAccess: function(component) {
    	var action = component.get("c.RejectLeaseAccess");
		action.setParams({ "lsac" : component.get("v.selectedLsac") });
        
        action.setCallback(this, function(response) {
            document.getElementById('access-approve-reject').style.display = 'none';
            var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
                console.log('rejectAccess response *** '+response.getReturnValue());
	        	var result = response.getReturnValue();
                if(result === true) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": $A.get("$Label.c.RET_Lease_Access_Request_Rejected_Success"),
                        "type": "success",
                        "duration": "10000"
                    });
                    toastEvent.fire();
                }else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": response.getError()[0].message,
                        "type": "error",
                        "duration":"10000"
                    });
                    toastEvent.fire();
	        	}
            }
            this.loadPendingApprovalLeases(component);
	    });
	    $A.enqueueAction(action);
    
	},
    navigateLeft: function(component) {
		var page = component.get("v.selectedPage");
		if(page > 1) {
			component.set('v.selectedPage', page - 1);
		}
		this.loadPendingApprovalLeases(component);
	},
	navigateRight: function(component) {
		var page = component.get("v.selectedPage");
		var pageLimit = component.get("v.totalPages");
		if(page < pageLimit) {
			component.set('v.selectedPage', page + 1);
		}
		this.loadPendingApprovalLeases(component);
	},
	changePageSize: function(component) {
		component.set("v.selectedPage", 1);
		this.loadPendingApprovalLeases(component);
	}
    
})