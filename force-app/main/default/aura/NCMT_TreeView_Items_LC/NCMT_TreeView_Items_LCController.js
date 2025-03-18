({
    doInit : function(component, event, helper) {
        component.set('v.createdItems', []);
        console.log('init new cmp2');
        var costTypes = ['','Shell', 'TI', "Security"];
        component.set('v.costTypes', costTypes);
        let itemData = helper.fetchData(component);
        itemData.then(function(res){
            //get lookup item deata
            console.log(res, 'res');
            component.set('v.isLevelFive', res.isLevelFiveUser);
            component.set('v.isLevelTwo', res.isLevelTwoUser);
            
            var isOandP = (res.project.Markup_Method__c == 'O&P Cost');
            console.log('isOandP', isOandP);
            component.set('v.isOandP', isOandP);

            component.set('v.recordTypeId', res.masterRecordTypeId);
            component.set('v.projectRecordType', res.project.Markup_Method__c);
            component.set('v.data', res.lookups);
            if(res.lookups.length > 0)
                component.set('v.costCatId', res.lookups[0].Level_2__c);
            // let initData = JSON.parse(JSON.stringify(res.lookups));
            // console.log('initData', initData);
            // component.set('v.initData', initData);
            //removed phase -- gm 5/8
            // component.set('v.phases', res.phaseList);
            component.set('v.pcsId', res.pcsId);
            component.set('v.crewMasterList', res.crewMasterList);            
            component.set('v.projectYear', res.project.Cost_Parameter_Date_FY__c);
            component.set('v.projectState', res.project.State__c);
            component.set('v.locationMultiplier', res.project.Location_Multiplier__c);
            component.set('v.salesTax', res.project.Sales_Tax__c);
            component.set('v.laborBurden', res.project.Labor_Burden_Tax__c);
            component.set('v.laborMarkups', res.laborMarkups);
            component.set('v.lookupTotal', res.lookupTotal);
            component.set('v.treeMarkupMethod', res.treeMarkupMethod);
            component.set('v.isLoaded', true);
        });
        
    },  
    handleSelect: function(component, event, helper) {
        //console.log(component.find("includeLoc").get("v.checked"));
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
        console.log(selItems);
    },
    
    handleSectionToggle: function (cmp, event, helper) {
        var openSections = event.getParam('openSections');

        if (openSections.length === 0) {
            cmp.set('v.activeSectionsMessage', "All sections are closed");
        }else{
            var sectionVal = helper.getOpenedSection(cmp, openSections);
            if(sectionVal){
                let getLData = helper.getLookupData(cmp, sectionVal);
                getLData.then(function(res){
                    console.log(res, 'res');
                    let dataObj = cmp.get('v.data').find(o =>o.Id === res.Id);
                    var newData =  Object.assign(cmp.get('v.data').find(o =>o.Id === res.Id), res);
                    newData.defaultDifficulty = newData.Difficulty_Factor_Percent__c;
                    newData.defaultItemNumber = newData.Line_Item_Number__c;
                    newData.defaultLaborHour = newData.Labor_Hours_txt__c;
                    newData.defaultHourlyRate = newData.Hourly_Rate_txt__c; 
                    newData.defaultMaterialUnitCost = newData.Material_Unit_Cost__c;
                    newData.defaulEquipmentUnitCost = newData.Equipment_Unit_Cost__c;
                    
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
        // get all selected contractors from lookups
        let selCons =component.get('v.selectedContractors');

        let laborMarkups = component.get('v.laborMarkups');
        console.log('laborMarkups', laborMarkups);
        //get checked items
        let selectedData = component.get('v.selItems');
        
        var item;
        var itemValidation;
        let displayMessage;        
        var valid = true;
        var errorName;
        
        function itemNumberChanged(items){
            if(!items.isNewRow){
                for(let i=0; i<items.Line_Item_Number__c.length-1; i++){
                    if(items.Line_Item_Number__c[i] != items.defaultItemNumber[i]){
                        errorName = 'itemNumber';
                        return true;
                    } 
                }
                if(items.Line_Item_Number__c != items.defaultItemNumber && items.Line_Item_Number__c[items.Line_Item_Number__c.length -1] != 'x'){
                    errorName = 'itemNumber';
                    return true;
                }
            }
        }
        
        //check if any items have waste factor > 20 and comments present, if not stop, throw error
        function needComment(items){
            if(!items.isNewRow
            && ((items.Difficulty_Factor_Percent__c != items.defaultDifficulty && !items.Comments__c) 
            || (items.Labor_Hours_txt__c != items.defaultLaborHour && !items.Comments__c) 
            || (items.Hourly_Rate_txt__c != items.defaultHourlyRate && !items.Comments__c) 
            || (items.Material_Unit_Cost__c != items.defaultMaterialUnitCost && !items.Comments__c) 
            || (items.Equipment_Unit_Cost__c != items.defaulEquipmentUnitCost && !items.Comments__c))){
                errorName = 'difficulty';
                return true;
            }
        }
        //check if any items have waste factor > 20 and comments present, if not stop, throw error
        // const isError = (items) => needComment(items) || itemNumberChanged(items);
        var errorVal = selectedData.some((items) => needComment(items) || itemNumberChanged(items));

        if(errorVal){
            console.log('errorName',errorName);
            // component.set('v.isError', true);
            displayMessage = helper.doErrors(component, errorName);
            component.set('v.createdItems', displayMessage);
            //var tempdata = encodeURIComponent(JSON.stringify(displayMessage));
			//component.set('v.createdItems', tempdata);
            component.set('v.isOpen', true);
            valid = false;
            return;
        }
        
        for(let i=0; i<selectedData.length; i++){
            item = selectedData[i];
            console.log(item);
            //find selected crew master from list where item id === selected item id, and set crew master lookup to selected crew master
            for (let c=0; c<selCms.length; c++){
                var cm = selCms[c];
                if (cm.hasOwnProperty(item.Id)){
                    item.NCMT_Crew_Master__c  = cm[item.Id]
                }
            }
            //find selected cotnractor ids from list where item id === selected item id, and set contractor lookup to selected contractor
            for (let n=0; n<selCons.length; n++){
                var sc = selCons[n];
                if (sc.hasOwnProperty(item.Id)){
                    item.NCMT_Contractor_ID__c  = sc[item.Id]
                }
                
            }
            for(let j=0; j<laborMarkups.length; j++){
                if((item.NCMT_Crew_Master__c && item.NCMT_Crew_Master__c == laborMarkups[j].NCMT_Crew_Master__c) || (item.NCMT_Labor__c && item.NCMT_Labor__c == laborMarkups[j].NCMT_Labor_Resource__c)){
                    item.Labor_Burden_Tax__c = laborMarkups[j].Labor_Burden_Tax__c; 
                }
            }
                helper.formatItemData(component, item);
            
            
        }
        if(valid){
            component.set('v.selectedItems',selectedData);
            helper.saveItems(component,event,selectedData).then(function(res){
                displayMessage = helper.doErrors(component, res);
                
                console.log('::res:::'+JSON.stringify(res));
                component.set('v.createdItems', displayMessage);
                //var tempdata = encodeURIComponent(JSON.stringify(displayMessage));
			    //component.set('v.createdItems', tempdata);
                component.set('v.isOpen', true);
                
            });
        }
        
    },
    
    addRow: function(component, event, helper) {
        //add new blank row to table
        let data = component.get('v.data');
        var dataLength = data.length;
        
        data.push({
            'Id': 'deleteMe'+dataLength,
            'isNewRow': true,
            'Description__c' : 'Userdefined - Add Description',
            'Unit__c' :'Ea.',
            'Quantity__c' : 0,
            'Labor_Hours_txt__c': 0,
            'Hourly_Rate_txt__c': 0,
            'Difficulty_Factor_Percent__' : 0,
            'Material_Unit_Cost__c' : 0,
            'Waste_Factor__c' : 0,
            'Equipment_Unit_Cost__c': 0,
            'Cost_Type__c': 'shell',
            'selected' : '',
            'Level_2__c' : component.get('v.costCatId'),
            'Level_2_Description__c' : component.get('v.level2desc'),
            'Level_3_Description__c' : component.get('v.level3desc'),
            'Level_4_Description__c' : component.get('v.level4desc'),
            'Level_5_Description__c' : component.get('v.level5desc')       
        });
        console.log(component.get('v.costCat'));
        console.log(data[(data.length-1)].Level_2_Description__c);
        console.log(data[(data.length-1)].isNewRow);
        component.set('v.data', data);
        
    }, redirectToStructure: function(component, event, helper) {
        component.set("v.isOpen",false);
        parent.window.location.href = "/"+ component.get('v.recordId');	
        
    },  redirectToItem: function(component, event, helper) {
        var targetId = event.target.id;
        window.open('/'+targetId, '_blank');
        
    },  closeModal: function(component, event, helper) {
        component.set('v.isOpen', false);
        component.set('v.itemsCreated', false);
        
    }, 
    addMoreItems: function(component, event, helper) {
        component.set('v.isOpen', false);
        component.set('v.itemsCreated', false);
        component.set('v.selItems', []);
        component.set('v.activeSections',[]);
        // let initData = component.get('v.initData');
        // component.set('v.data', initData);
        $A.enqueueAction(component.get('c.doInit'));
    },
    
    handleInclude: function(cmp, evt, hlp) {
        var item = evt.getSource().get('v.value');
        item.includeLocation = evt.getSource().get('v.checked');
        console.log(item);
        
    }
})