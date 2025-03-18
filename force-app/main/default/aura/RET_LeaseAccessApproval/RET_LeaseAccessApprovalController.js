({ 
   
	loadPendingApprovalLeases: function(component, event, helper) {
		helper.loadPendingApprovalLeases(component);
	}  ,
    navigateLeft: function(component, event, helper) {
		helper.navigateLeft(component);
	},
	navigateRight: function(component, event, helper) {
		helper.navigateRight(component);
	},
	changePageSize: function(component, event, helper) {
		helper.changePageSize(component);
	},
    showApproveRejectPopup: function(component, event, helper) {
		helper.showApproveRejectPopup(component, event);
    },
    cancelApproveReject: function(component, event, helper) {
        helper.cancelApproveReject(component);
    },
    approveAccess: function(component, event, helper) {
    	helper.approveAccess(component);
    },
    rejectAccess: function(component, event, helper) {
    	helper.rejectAccess(component);
	}
 
})