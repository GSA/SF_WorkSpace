({
	showHidePanel : function(component, event) {
		var gridId = event.getSource().get("v.name");
        var gridDivEle=document.getElementById(gridId);  
        var recInd = event.getSource().get("v.tabindex");
        if (gridDivEle.style.display == 'block' || gridDivEle.style.display==''){
            gridDivEle.style.display = 'none';

            var divPId = gridId+'plus'+recInd;   
            var IconPDivEle=document.getElementById(divPId);
            $A.util.addClass(IconPDivEle, 'slds-show');
            $A.util.removeClass(IconPDivEle, 'slds-hide');
            
            var divMId = gridId+'minus'+recInd;  
            var IconMDivEle=document.getElementById(divMId);
            $A.util.addClass(IconMDivEle, 'slds-hide');
            $A.util.removeClass(IconMDivEle, 'slds-show');            
            
        }else{
            gridDivEle.style.display = '';
            
            var divMId = gridId+'minus'+recInd;  
            var IconMDivEle=document.getElementById(divMId);
            $A.util.addClass(IconMDivEle, 'slds-show');
            $A.util.removeClass(IconMDivEle, 'slds-hide');
            
            var divPId = gridId+'plus'+recInd; 
            var IconPDivEle=document.getElementById(divPId);
            $A.util.addClass(IconPDivEle, 'slds-hide');
            $A.util.removeClass(IconPDivEle, 'slds-show');
        }
	},

	loadLeases: function(component) {
	    var action = component.get("c.getWrapperList");
	    console.log('**'+component.get("v.statusFilters"));
	    action.setParams({'statusFilters' : component.get("v.statusFilters"),
	    				  'selectedPage' : component.get("v.selectedPage"),
	    				  'pageSize' : component.get("v.pageSize") });
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	console.log(response.getReturnValue());
	        	var leaseListWrapper = response.getReturnValue();
	            component.set("v.wrapperList", leaseListWrapper.wrapperList);
                console.log('******wrapper',leaseListWrapper.wrapperList);
	            component.set("v.resultsHaveNext", leaseListWrapper.hasNext);
	            component.set("v.resultsHavePrev", leaseListWrapper.hasPrevious);
	            component.set("v.totalLeases", leaseListWrapper.totalLeases);
	            component.set("v.totalCases", leaseListWrapper.totalCases);
	            component.set("v.totalPages", leaseListWrapper.totalPages);
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error loading cases: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error loading cases.");
                }
	        }
	    });
	    $A.enqueueAction(action);
	},
	navigateLeft: function(component) {
		var page = component.get("v.selectedPage");
		if(page > 1) {
			component.set('v.selectedPage', page - 1);
		}
		this.loadLeases(component);
	},
	navigateRight: function(component) {
		var page = component.get("v.selectedPage");
		var pageLimit = component.get("v.totalPages");
		if(page < pageLimit) {
			component.set('v.selectedPage', page + 1);
		}
		this.loadLeases(component);
	},
	changePageSize: function(component) {
		component.set("v.selectedPage", 1);
		this.loadLeases(component);
	},
	goToCase: function(component, event) {
		var caseId = event.currentTarget.dataset.caseId;
		var caseEvent = component.getEvent("caseSelected");
        caseEvent.setParams({"caseId": caseId});
        caseEvent.fire();
	}
})