({
    searchHelper : function(component,event,getInputkeyWord) {
        console.log('here');
        // call the apex class method 
        var action = component.get("c.fetchLookUpValues");
        var objectName = component.get('v.objectAPIName');
        var fiscalYear = component.get('v.fiscalYear');
        console.log('getInputkeyWord='+getInputkeyWord);
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : objectName, 
            'fiscalYear': fiscalYear
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            console.log('state');
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                if(objectName == 'NCMT_Assembly_Lookup_Detail__c' ){
                    for(let i =0; i<storeResponse.length; i++){
                        storeResponse[i].Name =storeResponse[i].Level_2_Description__c + ' - '+ storeResponse[i].Level_3_Description__c + ' - '+storeResponse[i].Level_4_Description__c + ' - '+storeResponse[i].Description__c;
                    }          
                }
                if(objectName == 'NCMT_Contractor__c' ){
                    for(let i =0; i<storeResponse.length; i++){
                        storeResponse[i].Name =storeResponse[i].Name +' - ' +storeResponse[i].Contractor_Description__c;
                    }          
                }
                console.log(storeResponse, 'store response');
                
                // set searchResult list and list for filtering to return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                component.set("v.searchList", storeResponse);
                
                if(storeResponse.length> 0){
                    component.set('v.Message', '');
                }else{
                    component.set('v.Message', 'No results found...');
                }
                
            }else{
                console.log(state, 'fail state');
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },    
})