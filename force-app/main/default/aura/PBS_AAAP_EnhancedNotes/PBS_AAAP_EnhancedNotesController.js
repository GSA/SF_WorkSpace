({
    createNote: function(component, event, helper) {
        component.set("v.isCreateNote", true);
    },
    
    updateNote: function(component, event, helper) {
        component.set("v.noteId",event.getParam('value'));
        component.set("v.isUpdateNote", true);
    }
})