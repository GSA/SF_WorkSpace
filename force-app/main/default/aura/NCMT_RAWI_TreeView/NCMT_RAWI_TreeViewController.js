({     
    doInit : function(cmp, evt, hlp) {
         hlp.getItemData(cmp)
         .then(function(res){
            cmp.set('v.pcs', res.pcs);
            cmp.set('v.locationMultiplier', res.pcs.Project_Name__r.Location_Multiplier_Washington_D_C_1_0__c);
            let phaseOptions = [];
            for(var key in res.phases){
                phaseOptions.push({label: res.phases[key], value: key})
            }
            
            cmp.set('v.phases', phaseOptions);
             
            let raItems = res.items;
            var raArr = [];
            for (var key in raItems){
                let items = [];
                for(var key2 in raItems[key]){
                    items.push({label: key2, name: raItems[key][key2]});
                }
                raArr.push({label: key, items: items});
            }
            console.log('raArr', raArr );
            cmp.set('v.tree', raArr);
         });

    },
    handleSelect : function(cmp, evt) {
        cmp.set("v.body", '');
        var items = evt.getParam('name');
            if(items){
            $A.createComponent(
                "c:NCMT_RA_WorkItems",
                {
                 'pcsId' : cmp.get("v.pcsId"),
                 'locationMultiplier': cmp.get('v.locationMultiplier'),
                 'raItems': items, 
                 'phases' : cmp.get("v.phases"),
                }, 
                function(newcomponent) {
                    if(cmp.isValid())
                    {
                        var body = cmp.get("v.body");
                        body.push(newcomponent);
                        cmp.set("v.body", body);
                    }   
            });

        }
    }, doAddMore: function(cmp, evt){
        console.log('add more in parent');
        cmp.set("v.body", '');
        let initTree = cmp.get('v.tree');
        for(let i =0; i<initTree.length; i++){
            if(initTree[i].expanded)initTree[i].expanded = false;
        }
        cmp.set('v.tree', initTree);

    }, 
    openCloseConfirm:function(cmp, evt, hlp){
        let bool = !cmp.get('v.confirmBack');
        cmp.set('v.confirmBack', bool);
    },
    redirectToPcs: function(cmp, evt, hlp){
        cmp.set("v.isOpen",false);
        parent.window.location.href = "/"+ cmp.get('v.pcsId');	

    }
     
})