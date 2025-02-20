({
	init : function(component, event, helper) {
        console.log('help cmp');
        console.log('help type='+component.get("v.helpType"));
		//var myPageRef = component.get("v.pageReference");
        //var helpType = myPageRef.state.c__helptype;
        //component.set("v.helpType", helpType);
	},
    
    setHelp: function(cmp, evt, hlp) {
        //console.log(window.myHTML);
        cmp.set("v.helpText", window.myHTML);
    }
})