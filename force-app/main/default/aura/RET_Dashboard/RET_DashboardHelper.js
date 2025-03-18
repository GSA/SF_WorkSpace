({
	showSpinner: function() {
		document.getElementById('ret-dashboard-content').style.display = 'none';
		document.getElementById('spinner').style.display = 'block';
	},
	hideSpinner: function() {
		document.getElementById('ret-dashboard-content').style.display = 'block';
		document.getElementById('spinner').style.display = 'none';
	},
	goToCase: function(component, event) {
		var caseId = event.getParam("caseId");
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url" : "/edit-tax-submission?id=" + caseId,
            "isredirect" : false
        });
        urlEvent.fire();		
	},
	findLease: function(component, event, helper) {
    	var urlEvent = $A.get("e.force:navigateToURL");
			urlEvent.setParams({
			"url" : "/lease-search",
			"isredirect" : false
		});
    	urlEvent.fire();
	}, 
    userType: function(component) {
        console.log('userType helper method');
        var action = component.get("c.getUserType");
       	action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
                var returnedUserType = response.getReturnValue();
                console.log('UserType ** '+returnedUserType);
                component.set("v.userType" , returnedUserType);
            }
        });
        $A.enqueueAction(action);
    }
})