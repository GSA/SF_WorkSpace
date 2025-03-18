({
	getThemeData: function(component, event, helper) {
		helper.getThemeData(component);
        component.set("v.pageName",window.document.title);
	},
	jsInit: function(component, event, helper) {		
		helper.jQuerySetup();
        component.set("v.pageName",window.document.title);
	},
	locationChanged: function(component, event, helper) {
		//helper.setNavHighlight(component);
	}
})