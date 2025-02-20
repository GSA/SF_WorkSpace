({
    doInit : function(component, event, helper) {
        component.set('v.createdItems', []);
        console.log('init new cmp2');
        console.log('ESTFormat = ' + component.get("v.ESTFormat"));
        var costTypes = ['', 'Shell', 'TI', "Security"];
        component.set('v.costTypes', costTypes);
        
        let itemData = helper.fetchData(component);
        itemData.then(function(res){
            //get lookup item data
            console.log(res, 'res');
            component.set('v.data', res.lookups);
            //remove phasing gm 5_8
            // component.set('v.phases', res.phaseList);
            component.set('v.pcsId', res.pcsId);
            component.set('v.crewMasterList', res.crewMasterList);            
            component.set('v.projectYear', res.project.Cost_Parameter_Date_FY__c);
            component.set('v.projectState', res.project.State__c);
            component.set('v.locationMultiplier', res.project.Location_Multiplier__c);
            component.set('v.salesTax', res.project.Sales_Tax__c);
            component.set('v.laborBurden', res.project.Labor_Burden_Tax__c);
            component.set('v.treeMarkupMethod', res.treeMarkupMethod);

            component.set('v.recordTypeId', res.recordTypeId);
            var isOandP = (res.project.Markup_Method__c == 'O&P Cost');
            component.set('v.isOandP', isOandP);

            component.set('v.isLoaded', true);
            
        });
        
    }, handleSelect: function(component, event, helper) {
        
        var selItems = component.get('v.selItems');
        var selItem = event.getSource().get('v.text');
        //selItem.selected = !selItem.selected;
        if(selItem.selected){
            selItems.push(selItem);
        }else{
            for(var i = 0; i < selItems.length; i++){ 
                if(selItems[i].Id == selItem.Id){
                    selItems.splice(i, 1);
                }
                
            }
        }
        component.set('v.selItems', selItems);
        
    },
    
    handleSectionToggle: function (cmp, event) {
            var openSections = event.getParam('openSections');
    
            if (openSections.length === 0) {
                cmp.set('v.activeSectionsMessage', "All sections are closed");
            } else {
                cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
            }
    },
    
        handleSectionToggle2: function (cmp, event, helper) {
        var openSections = event.getParam('openSections');
        console.log('open sections', openSections);
        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        } else {
            var sectionVal = helper.getOpenedSection(cmp, openSections);
            if(sectionVal){
                let getLData = helper.getLookupData(cmp, sectionVal);
                getLData.then(function(res){
                    console.log(res, 'res');
                    let dataObj = cmp.get('v.data').find(o =>o.Id === res.Id);
                    console.log('dataObj' ,dataObj);
                    var newData =  Object.assign(cmp.get('v.data').find(o =>o.Id === res.Id), res);
                    var newDataAttr = cmp.get('v.data');
                    //var tempdata = encodeURIComponent(JSON.stringify(newDataAttr));
                    //cmp.set('v.data', tempdata);
                    cmp.set('v.data', newDataAttr);
                    
                    
                });
            }
            cmp.set('v.activeSectionsMessage', "Open sections: " + openSections.join(', '));
        }
    },
    
    
    handleClick:  function(component, event, helper) {
        //get all selected crew masters from lookups
        let selCms =component.get('v.selectedCrewMasters');
        // get all selected uniformats from lookups
        let selUFs =component.get('v.selectedUniformats');
        // get all selected contractors from lookups
        let selCons =component.get('v.selectedContractors');
        
        //get checked items
        let selectedData = component.get('v.selItems');
        
        var item;
        for(let i=0; i<selectedData.length; i++){
            
            item = selectedData[i];
            if(item.Id === undefined)
            {
                console.log('ID UNDEFINED');
            }
            
            //find selected crew master from list where item id === selected item id, and set crew master lookup to selected crew master
            for (let c=0; c<selCms.length; c++){
                var cm = selCms[c];
                if (cm.hasOwnProperty(item.Id)){
                    item.NCMT_Crew_Master__c  = cm[item.Id]
                }
            }
            //find selected unformat from list where item id === selected item id, and set unfiformat lookup to selected uniformat
            for (let u=0; u<selUFs.length; u++){
                var uf = selUFs[u];
                if (uf.hasOwnProperty(item.Id)){
                    item.NCMT_Assembly_Lookup_Detail__c  = uf[item.Id]
                }
                
            }
            //find selected cotnractor ids from list where item id === selected item id, and set contractor lookup to selected contractor
            for (let n=0; n<selCons.length; n++){
                var sc = selCons[n];
                if (sc.hasOwnProperty(item.Id)){
                    item.NCMT_Contractor_ID__c  = sc[item.Id]
                }
                
            }
            helper.formatItemData(component, item);
        }
        
        component.set('v.selectedItems',selectedData);
        helper.saveItems(component,event,selectedData).then(function(res){
            //var tempdata = encodeURIComponent(JSON.stringify(res));
			//component.set('v.createdItems', tempdata);
            component.set('v.createdItems', res);
            component.set('v.isOpen', true);
            
         });
        
    },
    
     redirectToStructure: function(component, event, helper) {
        console.log('recordId == ' +component.get('v.recordId'));
        console.log(parent);
        console.log(window);
        parent.window.location.href = "/"+ component.get('v.recordId');	
        parent.window.open('/'+ component.get('v.recordId'),'_parent');
    },  redirectToItem: function(component, event, helper) {
        var targetId = event.target.id;
        window.open('/'+targetId, '_blank');
        
    },  closeModal: function(component, event, helper) {
        component.set('v.isOpen', false);
    },   
    addMoreItems: function(component, event, helper) {
        component.set('v.isOpen', false);
        // component.set('v.itemsCreated', false);
        component.set('v.selItems', []);
        component.set('v.activeSections',[]);
        // let initData = component.get('v.initData');
        // component.set('v.data', initData);
        $A.enqueueAction(component.get('c.doInit'));
    }, 
    handleValueChange : function (component, event, helper) {
        //alert('Please enter comments for the change');
    }
    
})