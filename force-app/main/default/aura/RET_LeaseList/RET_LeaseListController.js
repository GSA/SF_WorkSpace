({
    showHidePanel : function(component, event, helper) {
        helper.showHidePanel(component,event);
    },

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
    manageAccess: function(component, event, helper) {
        //var leaseId = event.getSource().getLocalId();
        //console.log('***lease',leaseId);
        component.set("v.leaseNumber",event.target.id);
        component.set('v.manageAccessModalOpen',true);
    },
    
    closeModal: function(component, event, helper) {
        component.set('v.manageAccessModalOpen',false);
    }
})