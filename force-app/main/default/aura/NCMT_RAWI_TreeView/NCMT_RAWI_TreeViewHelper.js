({
    getItemData : function(cmp) {
        return new Promise($A.getCallback(function(resolve, reject){ 
         let  getItemData= cmp.get('c.init'); 
         getItemData.setParams({             
            'pcsId': cmp.get('v.pcsId'),
         }); 

         getItemData.setCallback(this, function(res){ 
          resolve(res.getReturnValue()); 
         }); 
         $A.enqueueAction(getItemData); 
        }));
    }

})