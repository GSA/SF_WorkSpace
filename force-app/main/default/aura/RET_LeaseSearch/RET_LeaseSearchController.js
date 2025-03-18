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
		helper.startTaxSubmission(component);
	},
    requestLeaseAccess: function(component, event, helper) {
    	helper.requestLeaseAccess(component, event);
	},
    cancelRequestAccess: function(component, event, helper) {
        helper.cancelRequestAccess();
    },
    confirmRequestLeaseAccess: function(component, event, helper) {
        helper.confirmRequestLeaseAccess(component);
    }
})