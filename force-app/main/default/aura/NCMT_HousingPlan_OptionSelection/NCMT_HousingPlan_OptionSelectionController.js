({
    init : function(component, event, helper) {
        helper.retrieveOptions(component, event, helper);
    },
    handleSave: function(component, event, helper){
        helper.saveOptions(component, event, helper);
    },
    recChange: function(component, event, helper){
        
    },
    addMove: function(component, event, helper){
        component.set('v.isLoaded', false);
        component.set('v.isSaved', false);
        component.set('v.saveError', null);
        var groupName = event.getSource().get("v.name"); 
        
        var opts = component.get('v.typeOptions'); //JSON.parse();
        
        console.log('groupName = ' +groupName);
        for (var i = 0; i < opts.length; i++){
            
            var opt = opts[i];
            console.log('opt.groupName = ' +opt.groupName, opt);
            if (opt.groupName == groupName){
                var newRec = JSON.parse(JSON.stringify(opt.recurrences[0]));
                
                for (var s = 0; s < newRec.subTypes.length; s++){
                    for (var c = 0; c < newRec.subTypes[s].options.length; c++){
                        var choice = newRec.subTypes[s].options[c];
                        choice.optSelect.Id = null;
                        choice.selected = false;
                    }
                }
                newRec.num = opts[i].recurrences.length + 1;
                opts[i].recurrences.push(newRec);
                console.log(newRec, opts[i].recurrences.length);
                opts[i].selectedRecurrence = opts[i].recurrences.length;
            }
            
        }

        component.set('v.typeOptions', opts);
        component.set('v.isLoaded', true);
    }
})