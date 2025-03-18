({
    fetchData: function(component ){
        //get lookup items from db
        var treeId = component.get('v.recordId');
        var costCat = component.get('v.costCat');
        return new Promise($A.getCallback(function(resolve, reject) {
            var getItems = component.get('c.init');
            getItems.setParams({
                "recordId": treeId,
                "costCat": costCat,
                "level2desc" : component.get("v.level2desc"),
                "level3desc" : component.get("v.level3desc"),
                "level4desc" : component.get("v.level4desc"),
                "level5desc" : component.get("v.level5desc"),
                "estFormat":component.get("v.ESTFormat"), 
                "fiscalYear" : component.get("v.projectYear")
            });
            getItems.setCallback(this, function(a) {
                resolve(a.getReturnValue());                
            });
            $A.enqueueAction(getItems);
            
        }));
        
    },
    getLookupData: function(cmp, lookupVal){
        var sectionIds = lookupVal;
        return new Promise($A.getCallback(function(resolve, reject) {
            var getSelected = cmp.get('c.getSelectedLoookup');
            getSelected.setParams({
                "lookupId": sectionIds 
            });
            getSelected.setCallback(this, function(a) {
                resolve(a.getReturnValue());                
            });
            $A.enqueueAction(getSelected);
            
        }));
        
        
        
    },
    getOpenedSection: function(cmp, openSections){
        var sectionId;
        for(let i=0; i<openSections.length; i++){
            var open = cmp.get('v.data').find(o =>o.Id === openSections[i]);            
            if(!open.Level_2_Description__c){
                sectionId = openSections[i];
                break;
            }
        }
        return sectionId;
        
    },
    saveItems: function(component,event, selectedData){
        //send selected lookups to db, create new des items. 
        console.log('selected data', selectedData);
        
        var itemsJson = JSON.stringify(selectedData);
        //var pcsId = compoent.get('v.pcsId');
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.saveItems');
            action.setParams({
                'itemList': itemsJson
                
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                if(state == "SUCCESS"){
                    resolve(a.getReturnValue());                
                    
                    
                } else if(state = "ERROR"){
                    
                    // console.log('error', error);
                    let errorMsg = a.getError();
                    resolve(a.getError()[0]);
                    // component.set('v.isError', true);
                    
                }
            });
            $A.enqueueAction(action);
            
        }));
        
        
    },
    // getLaborBurden(component, items){
    //     return new Promise(A.getCallback(function(resolve, reject){ 
    //      let  laborBurden= component.get('c.getLaborBurden'); 
    //      laborBurden.setParams({ 
    //         'items': items
    //      }); 
    //      laborBurden.setCallback(this, function(res){ 
    //       resolve(res.getReturnValue()); 
    //      }); 
    //      A.enqueueAction(laborBurden); 
    //     }));

    // },
     formatItemData: function(component, item){
        // removed phase -- gm 5/8
        // var defPhaseId = component.get('v.phases')[0].Id;
        // //if phase not selected, set to default
        // if(!item.Project_Phasing__c){
        //     item.Project_Phasing__c = defPhaseId;
        // }
        console.log('item'+JSON.stringify(item));
        if(item.includeLocation === undefined)
             item.includeLocation = true;
        console.log(item.includeLocation);
        //if item is not new row item, set des lookup id
        if(!item.Id.includes('deleteMe')){
            item.DES_Lookup_Detail__c = item.Id;
        }
        //set item values to correct name for des item, instead of des lookup 
        item.CSI_Line_Item_Number__c = item.Line_Item_Number__c;
        item.Labor_Unit_Hours__c = item.Labor_Hours_txt__c;
        item.Labor_Hours__c = item.Labor_Hours_txt__c * item.Quantity__c;
        item.Hourly_Rate__c = item.Hourly_Rate_txt__c;
        item.Equipment_Rental_Day__c = item.Equipment_Unit_Cost__c; //change to currency
        item.Project_Cost_Summary_ID__c =  component.get('v.pcsId');
        item.Tree_structure__c = component.get('v.recordId');
        item.item_type__c = component.get('v.ESTFormat');
        item.RecordTypeId =  component.get('v.recordTypeId');
        item.Location_Multiplier_Washington_DC_1_00__c = component.get('v.locationMultiplier');
        item.Sales_Tax__c = component.get('v.salesTax');
        item.Markup_Method__c = component.get('v.treeMarkupMethod');
        item.NCMT_Project_Location__c = component.get('v.projectState');
        item.Include_Location_Factor__c = item.includeLocation;
        //delete des lookup values which should not be on des item and/or will cause insert to fail
        //if project Markup_Method__c is not o&p cost remove o&p cost related vales from item lookup/item
        if(!component.get('v.isOandP')){
            //delete(item.O_P_Unit_Total__c);
            //delete(item.In_house_Unit_Total__c);
        }
        delete(item.Name);
        delete(item.DES_Uniformat_Lookup__r);
        delete(item.NCMT_Contractor_ID__r);
        delete(item.NCMT_Crew_Master__r);
        delete(item.NCMT_Labor__r);

    },   
    doErrors: function(component, value){
        var displayMessage;
        var messageText = 'No Items Created';
        if (value == 'difficulty'){
            displayMessage = 'FIELD_CUSTOM_VALIDATION_EXCEPTION, Comment required.'
            
        }else if(value == 'itemNumber'){
            displayMessage = 'Only the last digit of Line Item Number may be changed. And it Must be "x" ';
            
        }else if(value.length == 0){
            displayMessage = 'No Items selected. Please select and item to continue';
            
        }else if(value.message != null){
            displayMessage = value.message.split(':')[2]
            
        }else{
            displayMessage = value;
            component.set('v.itemsCreated', true);
            messageText = 'Items Created Successfully';
        }
        component.set('v.messageText', messageText);
        
        return displayMessage; 
    }
    
})