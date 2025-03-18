({
    getPcsData: function(cmp){
        return new Promise($A.getCallback(function(resolve, reject){ 
         let getPCS = cmp.get('c.getPCS'); 
         
         getPCS.setParams({ 
            'pcsId': cmp.get('v.pcsId')
        }); 
        getPCS.setCallback(this, function(res){ 
          resolve(res.getReturnValue()); 
         }); 
         $A.enqueueAction(getPCS); 
        }));

    },
    populateItemDropdowns: function(cmp, projectId){
        // let costCat = cmp.get('v.selectedCat');
        return new Promise($A.getCallback(function(resolve, reject){ 
         let  dropdownOptions = cmp.get('c.populateDropdowns'); 
         dropdownOptions.setParams({ 
             'projectId': projectId,
         }); 
         dropdownOptions.setCallback(this, function(res){ 
          resolve(res.getReturnValue()); 
         }); 
         $A.enqueueAction(dropdownOptions); 
        }));
    }, 
    createEmptyItems: function(cmp, rowsToAdd){
        let items =  cmp.get('v.items');
        //for numbering items, if no items, set index to 1, else set to index
        let iLength = items.length == 0? 1: items.length+1;    
        for(let i=0; i<rowsToAdd; i++ ){
            let itemObj = new Object({Work_Item_Code__c: '', NCMT_CEW_Work_Description__c: '',  CEW_Project_Agency__c: '', SQ_Ft__c: '',UOM__c: '' , Unit_Rate__c: '', Description__c: '', Project_Cost_Summary__c: cmp.get('v.pcsId'), index: iLength, isValid: true});
            iLength +=1;
            items.push(itemObj);
        }
        console.log('new items', items);
        cmp.set('v.items', items);


    }, getCewItems: function(cmp){
        return new Promise($A.getCallback(function(resolve, reject){ 
            let getCewItems = cmp.get('c.getCewItems'); 
            getCewItems.setParams({ 
            'pcsId': cmp.get('v.pcsId')
         }); 
        getCewItems.setCallback(this, function(res){ 
            resolve(res.getReturnValue()); 
         }); 
            $A.enqueueAction(getCewItems); 
        }));

    },formatSaveItems: function(cmp){

        //only save items with work item code populated
        let selectedItems = cmp.get('v.items').filter(item=>{
            return item.Work_Item_Code__c != ''
        });
        
        let wdCodes = cmp.get('v.wdCodes');
        for(let i=0; i<selectedItems.length; i++){
            for(let j=0; j<wdCodes.length; j++){
                if(selectedItems[i].NCMT_CEW_Work_Description__c == wdCodes[j].value){
                    selectedItems[i].WorkDescNumber__c	= wdCodes[j].label.split(" ")[0];
                }
            }
        }
        this.saveItems(cmp, selectedItems).then(function(res){
            console.log('::res:::'+JSON.stringify(res));
            cmp.set('v.createdItems', res);
            cmp.set('v.saveModalOpen', true);

        });
        console.log(cmp.get('v.items')); 
    },
    saveItems: function(cmp, itemsToSave){
        let itemsJson = JSON.stringify(itemsToSave);
        
        return new Promise($A.getCallback(function(resolve, reject){ 
         let  saveCewItems= cmp.get('c.saveCewItems'); 
         saveCewItems.setParams({
            'itemList': itemsJson
         }); 
         saveCewItems.setCallback(this, function(res){ 
                let state = res.getState();

                if(state == "SUCCESS"){     
                    if(!res.getReturnValue().length){      
                        cmp.set('v.messageText', 'No Items Created');
                        resolve('No items were created. "Work Item Code" must be assigned to save items. ')
                    }
                    else{
                        cmp.set('v.itemsCreated', true);
                        cmp.set('v.messageText', 'Items Created Sucessfully');
                    }
                    resolve(res.getReturnValue()); 
                } else if(state = "ERROR"){
                    let errorMsg = res.getError();
                    console.log('error +++++', errorMsg[0]);
                    cmp.set('v.messageText', 'Error Saving Items');
                    resolve(errorMsg[0].message);
                }
            }); 
         $A.enqueueAction(saveCewItems); 
        }));

    }
})