({
	initPage: function(component, event, helper) {
		helper.initPage(component);
	},
	initDocList: function(component, event, helper) {
		helper.loadExistingDocs(component);
	},
	uploadFile: function(component, event, helper) {
		helper.showUploadPanel(component);
	},
	cancelModal: function(component, event, helpler) {
		var dialogs = document.getElementsByClassName('ret-modal-container');
		for(var i = 0; i < dialogs.length; i++) {
			dialogs[i].style.display = 'none';
		}
	},
	saveDocument: function(component, event, helper) {		
		helper.saveDocument(component);
	},
	editDocument: function(component, event, helper) {
		helper.editDocument(component, event);
	},
	doneUploading: function(component, event, helper) {
		helper.doneUploading(component);
	},
	confirmRemoveDocument: function(component, event, helper) {
		helper.confirmRemoveDocument(component, event);
	},
	removeDocument: function(component, event, helper) {
		helper.removeDocument(component);
	},
	loadExistingDocs: function(component, event, helper) {
		helper.loadExistingDocs(component);
	},
	downloadAllAttachments: function(component, event, helper) {
        helper.dwnldAllAttachments(component);
	},
	saveNewDocument: function(component, event, helper) {	
        helper.saveNewDocument(component);
	},

})