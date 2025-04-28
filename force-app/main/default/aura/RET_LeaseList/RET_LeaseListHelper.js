({
	loadLeases: function(component) {
	    var action = component.get("c.getWrapperList");
	    //console.log('**'+component.get("v.statusFilters"));
        console.log('in loadLeases(), selectedPage: ' + component.get("v.selectedPage") + ', and pageSize: ' + component.get("v.pageSize"));
	    action.setParams({'statusFilters' : component.get("v.statusFilters"),
	    				  'selectedPage' : component.get("v.selectedPage"),
	    				  'pageSize' : component.get("v.pageSize") });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	//console.log(response.getReturnValue());
	        	var leaseListWrapper = response.getReturnValue();
	            component.set("v.wrapperList", leaseListWrapper.wrapperList);
                console.log('getWrapperList response: ' + JSON.stringify(leaseListWrapper));
	            component.set("v.resultsHaveNext", leaseListWrapper.hasNext);
	            component.set("v.resultsHavePrev", leaseListWrapper.hasPrevious);
	            component.set("v.totalLeases", leaseListWrapper.totalLeases);
	            component.set("v.totalCases", leaseListWrapper.totalCases);
	            component.set("v.totalPages", leaseListWrapper.totalPages);
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error loading leases: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error loading leases.");
                }
	        }
	    });
        console.log('Enqueing and about to call Apex controller getWrapperList()...');
	    $A.enqueueAction(action);
	},
	navigateLeft: function(component) {
		var page = component.get("v.selectedPage");
		if(page > 1) {
			component.set('v.selectedPage', page - 1);
		}
		this.loadLeases(component);
	},
	navigateRight: function(component) {
		var page = component.get("v.selectedPage");
		var pageLimit = component.get("v.totalPages");
        console.log('in navigateRight(), selectedPage: ' + page + ', pageLimit: ' + pageLimit);
		if(page < pageLimit) {
			component.set('v.selectedPage', page + 1);
		}
        console.log('now selectedPage = ' + (page+1) + ', now calling loadLeases()');
		this.loadLeases(component);
	},
	changePageSize: function(component) {
		component.set("v.selectedPage", 1);
		this.loadLeases(component);
	},
	goToCase: function(component, event) {
		var caseId = event.currentTarget.dataset.caseId;
		var caseEvent = component.getEvent("caseSelected");
        caseEvent.setParams({"caseId": caseId});
        caseEvent.fire();
	}
})