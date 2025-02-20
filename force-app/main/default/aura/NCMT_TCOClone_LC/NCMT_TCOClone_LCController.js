({
	init : function(component, event, helper) {
        //console.log('init new cmp!');
        var projId = component.get("v.recordId");
        //console.log('projId = ' + projId);
        helper.getOrigProject(component, projId);
    },
    
    cloneProject : function(component, event, helper) {
    	console.log('clone clicked!');
        var proj = component.get("v.proj");
        var projName = proj.Name;
        //console.log('projId = ' + proj.Id);
        //console.log(projName);
        event.getSource().set("v.label", "Saving...");
        event.getSource().set("v.disabled", true);
        helper.invokeClone(component, proj);
	},
    //SFWS-2427 Package 1 Corrections. Remove parent on line 21
    cancel : function(component, event, helper) {
        window.location.href = "/"+ component.get('v.recordId');
    }
})