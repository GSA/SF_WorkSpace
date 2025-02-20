({
    doInit : function(cmp, evt, hlp) {
        //set breadcrumb values
        let initItem =  cmp.get('v.raItems')[0];
        cmp.set('v.costType', initItem.Cost_Type__c);
        cmp.set('v.categoryType', initItem.Work_Item_Category_Type__c);
        cmp.set('v.subType', initItem.WI_Category_Sub_Type__c);
        console.log('locationMultiplier', cmp.get('v.locationMultiplier'));

        let items = cmp.get('v.raItems');
        for(let i =0; i<items.length; i++){
            items[i].Work_Item_Phase__c = cmp.get('v.phases')[0].value;
            items[i].Low__c = items[i].Low__c * cmp.get('v.locationMultiplier');
            items[i].High__c = items[i].High__c * cmp.get('v.locationMultiplier');

        }
        cmp.set('v.raItems', items);

    },
    saveItems: function(cmp, evt, hlp){
    console.log('items',cmp.get('v.raItems'));
        let itemsToSave = cmp.get('v.raItems').filter(item => item.selected == true);
        console.log('items to save', itemsToSave);
        if(itemsToSave.length ==0){
            cmp.set('v.saveModal', true);
            cmp.set('v.createdItems', 'No Items Selected. Please Select an Item to Save');
            cmp.set('v.modalHeader', 'No Items Created');
            return;
        }
        for(let i =0; i<itemsToSave.length; i++){
            itemsToSave[i].Work_Item_Type_ID__c = cmp.get('v.pcsId');
            if(itemsToSave[i].Id){
                Object.defineProperty(itemsToSave[i] , 'RA_WI_Lookup_Detail__c', Object.getOwnPropertyDescriptor(itemsToSave[i] , 'Id'));
                delete itemsToSave[i]['Id'];
            }
        }
        console.log(itemsToSave, 'i2s');
        hlp.saveItems(cmp, itemsToSave).then(function(res){
            cmp.set('v.saveModal', true);
            if(res.message != null){
                cmp.set('v.modalHeader', 'No Items Created');
                cmp.set('v.createdItems', res.message.split(':')[2])

            }else{
                cmp.set('v.itemsCreated', true);
                cmp.set('v.modalHeader', 'Items Created Sucessfully');
                cmp.set('v.createdItems', res);
            }
            console.log('save res', res);
        });
    }, addMoreItems :function(cmp, evt){
        let addMoreEvt = cmp.getEvent('addMoreEvt');
        addMoreEvt.fire();
    },
    goBack:function(cmp){
        cmp.set("v.isOpen",false);
        parent.window.location.href = "/"+ cmp.get('v.pcsId');	 
    },  
     closeModal: function(cmp) {
        cmp.set('v.saveModal', false);
        
    }, 
})