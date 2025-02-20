({
    doInit : function(component) {
     if (component.get("v.isUpdateNote") == true) {
            var noteRecord = component.get("v.note"); 
            var action = component.get("c.getNoteRecord");
            action.setParams({
                noteId : component.get("v.noteId")
            });
            action.setCallback(this,function(a){
                var state = a.getState();                
              //  alert(JSON.stringify(a.getReturnValue()));
                
                if(state == "SUCCESS") {
                    noteRecord.Title = a.getReturnValue().title;
                    noteRecord.Content = a.getReturnValue().content;
                    component.set("v.note",noteRecord);
                } else if(state == "ERROR"){
                    alert('Error in calling server side action');
                }
            });  
            $A.enqueueAction(action);
        }
    },
    
    create : function(component, event, helper) {       
        var noteRecord = component.get("v.note");
        //Calling the Apex Function
        var action = component.get("c.createNRecord");
        //Setting the Apex Parameter
        action.setParams({
            nt : noteRecord,     
            PrentId : component.get("v.recordId")  
        });
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            //check if result is successfull
            if(state == "SUCCESS"){
              //  alert('Note record created succefully!');
                window.location.reload();
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });  
        $A.enqueueAction(action);
        
    },
    
    closeModel : function (component, event, helper) {
        component.set("v.isCreateNote", false);
        component.set("v.isUpdateNote", false);
    },
    
    
    update : function(component, event, helper) {  
        var noteRecord = component.get("v.note");
       // alert(JSON.stringify(noteRecord));
        
        var action = component.get("c.updateNoteRecord");
        //Setting the Apex Parameter
        action.setParams({
            nt : noteRecord,
            noteId : component.get("v.noteId")
        });
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            //check if result is successfull
            if(state == "SUCCESS"){
               // alert('Note record updated succefully!');
                window.location.reload();
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });  
        $A.enqueueAction(action);        
    }
})