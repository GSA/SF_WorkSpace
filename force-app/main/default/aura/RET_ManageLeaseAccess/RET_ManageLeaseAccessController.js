({
    onInit : function(component, event, helper) {
		helper.fetchPBSLeaseAccess(component,event,helper);
    },
    
    checkboxSelect: function(component, event, helper) {
      // get the selected checkbox value  
      var selectedRec = event.getSource().get("v.value");
      // get the selectedCount attrbute value(default is 0) for add/less numbers. 
      var getSelectedNumber = component.get("v.selectedCount");
      var headerCheck = component.find("box3");
      // check, if selected checkbox value is true then increment getSelectedNumber with 1 
      // else Decrement the getSelectedNumber with 1     
      if (selectedRec == true) {
       getSelectedNumber++;
      } else {
       component.find("box3").set("v.value", false);
       getSelectedNumber--;   
      }
      // set the actual value on selectedCount attribute to show on header part. 
      component.set("v.selectedCount", getSelectedNumber);
    },
    
     selectAll: function(component, event, helper) {
    		//get the header checkbox value  
    		var selectedHeaderCheck = event.getSource().get("v.value");
          // get all checkbox on table with "boxPack" aura id (all iterate value have same Id)
          // return the List of all checkboxs element 
    		var getAllId = component.find("boxPack");
    		// If the local ID is unique[in single record case], find() returns the component. not array   
           if(! Array.isArray(getAllId)){
             if(selectedHeaderCheck == true){ 
                component.find("boxPack").set("v.value", true);
                component.set("v.selectedCount", 1);
             }else{
                 component.find("boxPack").set("v.value", false);
                 component.set("v.selectedCount", 0);
             }
           }else{
             // check if select all (header checkbox) is true then true all checkboxes on table in a for loop  
             // and set the all selected checkbox length in selectedCount attribute.
             // if value is false then make all checkboxes false in else part with play for loop 
             // and select count as 0 
              if (selectedHeaderCheck == true) {
              for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.value", true);
               component.set("v.selectedCount", getAllId.length);
              }
              } else {
                for (var i = 0; i < getAllId.length; i++) {
                  component.find("boxPack")[i].set("v.value", false);
                  component.set("v.selectedCount", 0);
              }
             } 
           }  
   	},
    
    revokeAccessForSelected: function(component, event, helper) {
      // create var for store record id's for selected checkboxes  
      var leaseId = [];
      // get all checkboxes 
      var getAllId = component.find("boxPack");
      // If the local ID is unique[in single record case], find() returns the component. not array
      if(! Array.isArray(getAllId)){
             if (getAllId.get("v.value") == true) {
               leaseId.push(getAllId.get("v.text"));
             }
       }else{
         // play a for loop and check every checkbox values 
         // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
       		for (var i = 0; i < getAllId.length; i++) {
            	if (getAllId[i].get("v.value") == true) {
             		leaseId.push(getAllId[i].get("v.text"));
           		}
          	}
      } 
      console.log('****leaseId',leaseId);
      // call the helper function and pass all selected record id's.    
      helper.revokeLeaseAccessHelper(component, event, leaseId);       
 	  },
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    }

    
    
    
})