({
    fetchData: function(component ){
        //get lookup items from db
        var treeId = component.get('v.recordId');
        var costCat = component.get('v.costCat');
        console.log('component.get("v.level6desc = ' + component.get("v.level6desc") +' tree id = ' +treeId);
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var getItems = component.get('c.initGSA');
            getItems.setParams({
                "recordId": treeId,
                "costCat": costCat,
                "level2desc" : component.get("v.level2desc"),
                "level3desc" : component.get("v.level3desc"),
                "level4desc" : component.get("v.level4desc"),
                "level5desc" : component.get("v.level5desc"),
                "level6desc" : component.get("v.level6desc"),
                "ESTFormat"  : component.get("v.ESTFormat"),
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
            var getSomething = cmp.get('c.getSelectedLoookup');
            getSomething.setParams({
                "lookupId": sectionIds 
            });
            getSomething.setCallback(this, function(a) {
                resolve(a.getReturnValue());                
            });
            $A.enqueueAction(getSomething);
            
        }));   
    },
    
    getOpenedSection: function(cmp, openSections){
        var sectionId;
        for(let i=0; i<openSections.length; i++){
            var something = cmp.get('v.data').find(o =>o.Id === openSections[i]);
            console.log('before if', something);
            
            if(!something.Level_2_Description__c){
                sectionId = openSections[i];
                break;
            }
        }
        
        return sectionId;
    },
    
    saveItems: function(component,event, selectedData){
        console.log('helper save items');
        //send selected lookups to db, create new des items. 
        var itemsJson = JSON.stringify(selectedData);
        //var pcsId = compoent.get('v.pcsId');
        
        return new Promise($A.getCallback(function(resolve, reject) {
            var action = component.get('c.saveItemsGSA');
            action.setParams({
                'itemList': itemsJson,
                'treeStruc': component.get('v.recordId')
            });
            action.setCallback(this, function(a) {
                var state = a.getState();
                //console.log('STATE = ' + state);
                if(state == 'SUCCESS')
                	resolve(a.getReturnValue());
                else if(state == 'ERROR') {
                    var errors = action.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) {
                            var err = errors[0].message.split(':')[4];
                            err = err.split(',')[1];
                            
                            //add deleted Ids back to selected Items 
                            //so they can be re-saved
                            if(!alert(err))
                            {
                                var deleted = component.get("v.deletedIds");
                                var selected = component.get("v.selItems");
                                for(var i = 0; i<selected.length; i++)
                                {
									selected[i].Id = deleted[i];
                                }                           
                            };
                        }
                	}
                }                
            });
            $A.enqueueAction(action);     
        }));
        
        
    }, formatItemData: function(component, item){
        // var defPhaseId = component.get('v.phases')[0].Id;
        
        // //if phase not selected, set to default
        // if(!item.Project_Phasing__c){
        //     item.Project_Phasing__c = defPhaseId;
        // }
        console.log('item'+JSON.stringify(item));
        //if item is not new row item, set des lookup id
        if(!item.Id.includes('deleteMe')){
            if(component.get("v.ESTFormat")=='Master Format'){
            	item.DES_Lookup_Detail__c = item.Id;
            }else if(component.get("v.ESTFormat")=='Uniformat' ||
                      component.get("v.ESTFormat")=='GSA Assemblies'){
                item.NCMT_Assembly_Master__c = item.Id;
            }    
        }
        //set item values to correct name for des item, instead of des lookup
        item.CSI_Line_Item_Number__c = item.Name; 
        item.Total_Material_Cost__c = (item.Quantity__c + (item.Waste_Factor__c * item.Quantity__c/100)) * item.Material_Unit_Cost__c;
        item.Total_Labor_Cost__c = item.Labor_Hours_txt__c *item.Hourly_Rate_txt__c;
        item.Total_Equipment_Cost__c = item.Equipment_Rental_Day_txt__c * item.Quantity__c;
        item.Material_Adjusted__c = item.Quantity__c * (1 + item.Waste_Factor__c/100);
        item.Labor_Hours__c = item.Labor_Hours_txt__c;
        item.Hourly_Rate__c = item.Hourly_Rate_txt__c;
        item.Equipment_Rental_Day__c = item.Equipment_Rental_Day_txt__c;
        item.Project_Cost_Summary_ID__c =  component.get('v.pcsId');
        item.Tree_structure__c = component.get('v.recordId');
        item.RecordTypeId =  component.get('v.recordTypeId');
        item.Markup_Method__c = component.get('v.treeMarkupMethod');
        item.NCMT_Project_Location__c = component.get('v.projectState');
        item.Location_Multiplier_Washington_DC_1_00__c = component.get('v.locationMultiplier');
        item.Sales_Tax__c = component.get('v.salesTax');
        item.Labor_Burden_Tax__c = component.get('v.laborBurden');
        
        item.O_P_Unit_Total__c = item.Total_Cost_OP__c;
        item.In_house_Unit_Total__c = (item.Material_Unit_Cost__c + item.Installation_Cost__c);
        
        item.Labor_Cost__c = item.Assembly_Labor_Cost_Unit__c * item.Quantity__c;
        item.Original_Minimum_Cost__c = item.Minimum_Cost__c;
         console.log('Original Minimum Cost: ' + item.Original_Minimum_Cost__c);
        

        //Save item Ids to deletedIds list in case the insert fails validation
        var deletedIds = component.get("v.deletedIds");
        deletedIds.push(item.Id);
        
        //delete des lookup values which should not be on des item and/or will cause insert to fail
        delete(item.Id);
        delete(item.Name);
        delete(item.DES_Uniformat_Lookup__r);
        delete(item.NCMT_Contractor_ID__r);
        delete(item.NCMT_Crew_Master__r);
    },   
})