({
    expandDetails : function(component, event, helper) {
        var treeId = event.getSource().get("v.name");
        console.log('---- ' +treeId);
        var elems = document.getElementsByClassName(treeId +'-details');
        for (var i = 0; i < elems.length; i++) {
            console.log('---- ' +elems[i].style.display);
            elems[i].style.display = (elems[i].style.display == 'none' ? '' : 'none');
        }
        var l = event.getSource().get("v.label");
        event.getSource().set("v.label",(l == '+' ? '-' : '+'));
        
    },
    
    doInit : function(cmp, evt, hlp) {
        console.log(cmp.get('v.treeObj'));
        console.log(cmp.get('v.catsUsed'));
        console.log(cmp.get('v.markuppctnts.Prime_Con_SelfWork_HomeOff_Overhead__c'));
    }
})