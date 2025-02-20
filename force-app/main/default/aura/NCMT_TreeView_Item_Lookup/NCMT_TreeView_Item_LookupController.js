({
    showModal:  function(cmp,event,helper){
        var getInputkeyWord = '';
        helper.searchHelper(cmp,event,getInputkeyWord);
        cmp.set('v.modalOpen', true);
    },
    closeModal:  function(cmp,event,helper){
        cmp.set('v.modalOpen', false);
        
        
    },
    
    search : function(cmp, evt, hlp){
        console.log('in search');
        var inputVal = cmp.get("v.SearchKeyWord");
        console.log('inputVal', inputVal);

        hlp.searchHelper(cmp,evt,inputVal);
        /*
        var records = cmp.get("v.listOfSearchRecords"); 
        
        console.log('records', records);
        // filter list of searched records for only including search string
        var filtRecords = records.filter(rec=> Object.keys(rec).some(key => rec[key].toLowerCase().includes(inputVal.toLowerCase())));
        
        console.log('filtRecords', filtRecords);
        cmp.set("v.searchList", filtRecords);
        if(filtRecords.length> 0){
            cmp.set('v.Message', '');
        }else{
            cmp.set('v.Message', 'No results found...');
        }*/
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(cmp, event, helper) {
        // get the selected Account record from the component event 	 
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        cmp.set("v.selectedRecord", selectedAccountGetFromEvent); 
        
        //get currently selected lookup records
        var cmList = cmp.get('v.cmList');
        let currentWiId = cmp.get('v.currentWiId');
        console.log('v.currentWiId', currentWiId);
        let selectedRecordId = cmp.get('v.selectedRecord').Id;
        let selectedRecordName = cmp.get('v.selectedRecord').Name;
        
        
        cmp.set('v.currentValue', selectedRecordName);
        var hasValue = false
        //if current selected item has a value for lookup, set value to new selected lookup
        for(let i = 0; i<cmList.length; i++){
            if(cmList[i].hasOwnProperty(currentWiId)){
                cmList[i][currentWiId] = selectedRecordId;
                hasValue = true;
            }                   
        }
        //if current selected item does not havea value for lookup, add looup value to item
        if(!hasValue){cmList.push({[currentWiId]:selectedRecordId });}
        cmp.set('v.cmList', cmList);
        
        
        //close modal, set icon to close, set hover title to selected record     
        cmp.set('v.modalOpen', false);
        cmp.set('v.uniformatIcon', 'utility:close');
        cmp.set('v.hoverMessage', selectedRecordName );
        
        
    }
})