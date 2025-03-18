({
	initPage: function(component, event, helper) {
		helper.loadPageData(component);
	},
	cancelModal: function() {
		var dialogs = document.getElementsByClassName('ret-modal-container');
		for(var i = 0; i < dialogs.length; i++) {
			dialogs[i].style.display = 'none';
		}
	},
	editTaxData: function() {
		document.getElementById('tax-edit').style.display = 'block';
	},
	cancelTaxEdit: function(component, event, helper) {
		helper.resetCase(component);
	},
	saveTaxData: function(component, event, helper) {
		helper.saveCase(component);
	},
	submitTaxData: function(component, event, helper) {
		helper.submitTaxData(component);
	},
	verifyRequiredDocuments: function(component, event, helper) {
		helper.verifyRequiredDocuments(component);
	}
})