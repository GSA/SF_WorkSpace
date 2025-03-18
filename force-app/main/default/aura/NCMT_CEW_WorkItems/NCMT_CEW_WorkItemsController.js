({
    init: function(cmp, evt, hlp){
        let getPcs = hlp.getPcsData(cmp);
        getPcs.then(function(res){
        if(res){
            console.log('res', res);
            cmp.set('v.projectName', res.Project_Name__r.Name)
            let selectedCat = res.Cost_Category_Code__c + ' - ' + res.Cost_Category_Description__c;
            cmp.set('v.selectedCat', selectedCat);
        }
        return hlp.populateItemDropdowns(cmp, res.Project_Name__c);
        }).then(function(res){
            let wdCodes = [];
            let needABwdCodes = [];
            for(var key in res.workDescOptions){
                wdCodes.push({label:  res.workDescOptions[key], value:  key})
                //make ab code requires for desc code 6,7,8
               if(['6','7','8'].includes(res.workDescOptions[key].split(" ")[0])){needABwdCodes.push(key)};
            }
            cmp.set('v.wdCodes', wdCodes);
            cmp.set('v.needABwdCodes', needABwdCodes);
            let abCodes = [];
            for(var key in res.abCodeOptions){
                abCodes.push({label:  res.abCodeOptions[key], value:  key})
            }
            cmp.set('v.abCodes', abCodes);
            
            cmp.set('v.items', []);
            hlp.createEmptyItems(cmp, 5);
        })
    }, 
    openModal: function(cmp, evt, hlp) {
       let cewItems = hlp.getCewItems(cmp);
       cewItems.then(function(res){
           cmp.set('v.cewItems', res);
       })
       cmp.set("v.isModalOpen", true);
    },
    
    openHelpModal: function(cmp, evt, hlp) {
        window.open('/apex/NCMT_CEW_Help_Launcher?&helpType=workitem', '_blank');
    },

    closeModal: function(cmp, evt, hlp) {
       cmp.set("v.isModalOpen", false);
    }, 
    closeHelpModal: function(cmp, evt, hlp) {
       cmp.set("v.showHelp", false);
    }, 
    callAddRow: function(cmp, evt,  hlp){
        hlp.createEmptyItems(cmp);
    }, 
    handleSaveItems: function(cmp, evt, hlp){
        //check if any items missing wi code, if so give confirm save modal
        let allItems = cmp.get('v.items').filter(item=>{
            return item.NCMT_CEW_Work_Description__c != '' && item.Work_Item_Code__c == ''
        });
        if(allItems.length > 0){
            cmp.set('v.showConfirmSave', true);

        }else{
            hlp.formatSaveItems(cmp)
        }
    },
    modalSaveItem: function(cmp, evt, hlp){
        cmp.set('v.showConfirmSave', false);
        hlp.formatSaveItems(cmp);
    },
    closeConfirmSave:function(cmp){
        cmp.set('v.showConfirmSave', false);
    },
    closeSaveModal: function(cmp, evt, hlp) {
        cmp.set('v.saveModalOpen', false);
        cmp.set('v.itemsCreated', false);
    },
     redirectToItem: function(cmp, evt, hlp) {
        var targetId = evt.target.id;
        window.open('/'+targetId, '_blank');
    }, 
    redirectToPcs: function(cmp, evt, hlp){
        cmp.set("v.isOpen",false);
        parent.window.location.href = "/"+ cmp.get('v.pcsId');	

    }, confirmRemove: function(cmp, evt, hlp){
        let bool = !cmp.get('v.showConfirm');
        cmp.set('v.currentDeleteTarget', evt.target.name);
        cmp.set('v.showConfirm', bool);
    },
    removeLineItem: function(cmp, evt, hlp){ 
        let index = parseInt(cmp.get('v.currentDeleteTarget')) -1 ;
        let  items = cmp.get('v.items');

        items.splice(index, 1);
        for(let i=0; i<items.length; i++){
            items[i].index = i +1;
        }
        cmp.set('v.items', items);
        cmp.set('v.showConfirm', false);

    }, addRows:function(cmp, evt, hlp){
        let inputField = cmp.find('rowNumber');
        let addRowNumber;

        if(inputField){
            addRowNumber = parseInt(inputField.get('v.value'));
        }else{
            addRowNumber = 1;
        }
        let currentItemNumber = cmp.get('v.items').length;
        if(addRowNumber + currentItemNumber <=30 ){
            hlp.createEmptyItems(cmp, addRowNumber);
            cmp.set('v.showAddRow', false);
            if(inputField){inputField.set('v.value', '');}
        }else{
            inputField.setCustomValidity("Total Number of Items to Add Must be 30 or Less");
            inputField.reportValidity()
        }        

    }, showHideAddRows: function(cmp, evt, hlp){
        let bool = !cmp.get('v.showAddRow');
        cmp.set('v.showAddRow', bool);
    }, 
    checkAbCodes: function(cmp, evt, hlp){
        let items =  cmp.get('v.items');
        let itemIndex = evt.getSource().get('v.name') -1;
        if(cmp.get('v.needABwdCodes').includes(items[itemIndex].NCMT_CEW_Work_Description__c)){
            items[itemIndex].needsAbCode = true; 
        }
        else{
            items[itemIndex].needsAbCode = false; 
        }
        console.log('item',   items[itemIndex]);
        cmp.set('v.items', items);
    },
    openCloseConfirm:function(cmp, evt, hlp){
        let bool = !cmp.get('v.confirmBack');
        cmp.set('v.confirmBack', bool);
    },
    showChanged:function(cmp, evt, hlp){
        evt.currentTarget.style.background = '#fbffca'

     }



 })