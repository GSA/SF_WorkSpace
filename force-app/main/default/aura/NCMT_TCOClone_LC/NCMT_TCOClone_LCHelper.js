({
	getOrigProject : function(component, projId) {
        //console.log('helper getOrigProject');
        var action = component.get("c.getProject");
        action.setParams({projId : projId});
        action.setCallback(this, function(response) {
            var state = response.getState();
           if (state == "SUCCESS")
           {
               var proj = response.getReturnValue();
               //console.log(proj);
               component.set("v.proj", proj);
           }
        });
        $A.enqueueAction(action);	
	},
    
    invokeClone : function(component, proj) {
        console.log('helper invokeClone');
        
        var jsonProj = JSON.stringify(proj);
        //console.log(jsonProj);
        
        var action = component.get("c.cloneTCOProject");
        action.setParams({
            proj: jsonProj
        });
        action.setCallback(this, function(response) {
           var state = response.getState();
           if (state == "SUCCESS")
           {
               var cloneId = response.getReturnValue();
				console.log('CLONED: ' + cloneId);
            //SFWS-2374 parent.window.location.href = '/'+ cloneId was not functioning in Lightning
              window.location.href = '/'+ cloneId;
           }
            else if(state == 'ERROR') {
                    var errors = action.getError();
                    if (errors) 
                    {
                        //console.log(errors[0]);
                        alert(errors[0].message);
                	}
                }         
        });
        $A.enqueueAction(action);
    }

})