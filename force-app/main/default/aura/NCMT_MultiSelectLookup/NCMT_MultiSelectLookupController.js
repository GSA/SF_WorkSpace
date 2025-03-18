({
    onblur : function(cmp,evt,hlp){
        // on mouse leave clear the listOfSeachRecords & hide the search result cmp 
        cmp.set("v.listOfSearchRecords", null );
        cmp.set("v.SearchKeyWord", '');
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(cmp,evt,hlp){
        // show the spinner,show child search result cmp and call hlp function
        $A.util.addClass(cmp.find("mySpinner"), "slds-show");
        cmp.set("v.listOfSearchRecords", null ); 
        var forOpen = cmp.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        hlp.searchHelper(cmp,evt,getInputkeyWord);
    },
    
    keyPressController : function(cmp, evt, hlp) {
        $A.util.addClass(cmp.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = cmp.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the hlp 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = cmp.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            hlp.searchHelper(cmp,evt,getInputkeyWord);
        }
        else{  
            cmp.set("v.listOfSearchRecords", null ); 
            var forclose = cmp.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(cmp,evt,heplper){
        var selectedPillId = evt.getSource().get("v.name");
        var AllPillsList = cmp.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i].Id == selectedPillId){
                AllPillsList.splice(i, 1);
                cmp.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        cmp.set("v.SearchKeyWord",null);
        cmp.set("v.listOfSearchRecords", null );      
        cmp.find('searchBox').set('v.disabled', false);

    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(cmp, evt, hlp) {
        let maxSelectedLength = cmp.get('v.maxSelectedLength');
        cmp.set("v.SearchKeyWord",null);
        // get the selected object record from the cmp evt 	 
        var listSelectedItems =  cmp.get("v.lstSelectedRecords");
        console.log('selectedLength 1', listSelectedItems.length);
        var selectedAccountGetFromEvent = evt.getParam("recordByEvent");
        listSelectedItems.push(selectedAccountGetFromEvent);
        cmp.set("v.lstSelectedRecords" , listSelectedItems); 
        console.log('selectedLength 2', listSelectedItems.length);
        if(listSelectedItems.length >= maxSelectedLength){
            cmp.find('searchBox').set('v.disabled', true);
        }
        var forclose = cmp.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
})