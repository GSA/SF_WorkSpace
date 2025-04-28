({
    loadLeases: function(component, event, helper) {
		helper.loadLeases(component);
	},
	goToCase: function(component, event, helper) {
		helper.goToCase(component, event);
	},
	navigateLeft: function(component, event, helper) {
		helper.navigateLeft(component);
	},
	navigateRight: function(component, event, helper) {
		helper.navigateRight(component);
	},
	changePageSize: function(component, event, helper) {
		helper.changePageSize(component);
	},
    manageLease: function(component, event, helper) {
		//component.set('v.manageAccessModalOpen',true);
        var leaseId = event.target.id;
		var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
			"url": "/RET-DocumentSubmissions?leaseNumber=" + leaseId 
		});
		urlEvent.fire();
       /* var caseId = event.target.id;
		var urlEvent = $A.get("e.force:navigateToURL");
    	urlEvent.setParams({
			"url": "/edit-tax-submission?id=" + caseId 
		});
		urlEvent.fire();*/
    }
    //closeModal: function(component, event, helper) {
    //    component.set('v.manageAccessModalOpen',false);
    //}
})