({
	findLease: function(component, event, helper) {
		helper.findLease(component);
	},
	navigateLeft: function(component, event, helper) {
		helper.navigateLeft(component);
	},
	navigateRight: function(component, event, helper) {
		helper.navigateRight(component);
	},
	newSearch: function(component, event, helper) {
		helper.newSearch(component);
	},
	confirmStartSubmission: function(component, event, helper) {
		helper.confirmStartSubmission(component, event);
	},
	cancelTaxSubmission: function(component, event, helper) {
		helper.cancelTaxSubmission();
	},
	startTaxSubmission: function(component, event, helper) {
		helper.startTaxSubmission(component, event);
	}
    /* Commented out for 2024-2025 RET Surge to no longer use lease access functionality
    requestLeaseAccess: function(component, event, helper) {
    	helper.requestLeaseAccess(component, event);
	},
    cancelRequestAccess: function(component, event, helper) {
        helper.cancelRequestAccess();
    },
    confirmRequestLeaseAccess: function(component, event, helper) {
        helper.confirmRequestLeaseAccess(component);
    } */
})