({
	handleSearch : function(component, event, helper) {
        event.preventDefault();
        window.location = '/leasing/s/global-search/'+document.getElementById('extended-search-field-small').value;
	}
})