({
    // getItemData : function(cmp) {
    //     return new Promise($A.getCallback(function(resolve, reject){ 
    //      let  getItemData= cmp.get('c.init'); 
    //      getItemData.setParams({             
    //         // 'costType':   cmp.get('v.costType'),
    //         // 'categoryType':cmp.get('v.categoryType'),
    //         // 'subType': cmp.get('v.subType')
    //      }); 
    //      getItemData .setCallback(this, function(res){ 
    //       resolve(res.getReturnValue()); 
    //      }); 
    //      $A.enqueueAction(getItemData); 
    //     }));
    // }, 
    saveItems: function(cmp, items){
        let itemsJson = JSON.stringify(items);
        return new Promise($A.getCallback(function(resolve, reject){ 
         let saveWorkItems = cmp.get('c.saveRaWorkItems'); 
         saveWorkItems.setParams({ 
             'itemList': itemsJson
         }); 
         saveWorkItems.setCallback(this, function(res){ 
            let state = res.getState();
            if(state == "SUCCESS"){

                resolve(res.getReturnValue(), 'success'); 

            } else if(state = "ERROR"){
                    
                // console.log('error', error);
                let errorMsg = res.getError()[0];
                console.log(errorMsg);
                resolve(errorMsg);
                // component.set('v.isError', true);
            }
         }); 
         $A.enqueueAction(saveWorkItems); 
        }));

    }
})