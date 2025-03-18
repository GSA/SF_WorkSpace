({
	showSpinner: function() {
		document.getElementById('lease-search').style.display = 'none';
		document.getElementById('spinner').style.display = 'block';
	},
	hideSpinner: function() {
		document.getElementById('lease-search').style.display = 'block';
		document.getElementById('spinner').style.display = 'none';
	},
	findLease: function(component) {
		this.showSpinner();
                console.log('inside findLease');
		var action = component.get("c.getLeaseResults");
		action.setParams({ "template" : component.get("v.lease"),
						   "selectedPage" : component.get("v.selectedPage"),
						   "pageSize" : component.get("v.pageSize"),
						   "buildingName" : component.get("v.buildingName"),
						   "buildingAddress" : component.get("v.buildingAddress"),
						   "buildingState" : component.get("v.buildingState"),
						   "buildingCity" : component.get("v.buildingCity"),
						   "buildingZipCode" : component.get("v.buildingZipCode") });
	    action.setCallback(this, function(response) {
	    	this.hideSpinner();

	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	var resultWrapper = response.getReturnValue();
	        	if(resultWrapper.leaseWrapperList.length > 0) {
	        		component.set('v.wrapperList', resultWrapper.leaseWrapperList);
	        		component.set('v.totalResults', resultWrapper.totalResults);
	        		component.set('v.totalPages', resultWrapper.totalPages);
	        		component.set('v.resultsHavePrev', resultWrapper.hasPrevious);
	        		component.set('v.resultsHaveNext', resultWrapper.hasNext);
	        	} else {
				    var toastEvent = $A.get("e.force:showToast");
				    toastEvent.setParams({
				        "message": $A.get("$Label.c.RET_No_Leases_Match_Search_Criteria"),
				        "type": "info"
				    });
				    toastEvent.fire();
	        	}

	        } else {
			    var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Error",
			        "message": response.getError()[0].message,
			        "type": "error"
			    });
			    toastEvent.fire();
	        }
	    });
	    $A.enqueueAction(action);
	},
	navigateLeft: function(component) {
		var page = component.get("v.selectedPage");
		if(page > 1) {
			component.set('v.selectedPage', page - 1);
		}
		this.findLease(component);
	},
	navigateRight: function(component) {
		var page = component.get("v.selectedPage");
		var pageLimit = component.get("v.totalPages");
		if(page < pageLimit) {
			component.set('v.selectedPage', page + 1);
		}
		this.findLease(component);
	},
	newSearch: function(component) {
		component.set("v.lease", {'sobjectType' : 'PBS_Lease__c'});
		component.set("v.buildingName", '');
		component.set("v.buildingAddress", '');
		component.set("v.buildingCity", '');
		component.set("v.buildingState", '');
		component.set("v.buildingZipCode", '');
		component.set("v.wrapperList", []);
	},
	confirmStartSubmission: function(component, event) {
		var selectedLease = event.currentTarget;
		var leaseId = selectedLease.dataset.leaseid;
		var wrapperList = component.get("v.wrapperList");
		var wrapper;

		for(var i = 0; i < wrapperList.length; i++) {
			wrapper = wrapperList[i];
			if(leaseId == wrapper.lease.Id) {
				component.set("v.selectedLeaseId", wrapper.lease.Id);
				if(wrapper.leaseAccess != null && wrapper.leaseAccess.Status__c != '') {
					component.set("v.selectedLeaseAccessStatus", wrapper.leaseAccess.Status__c);
                } else {
					component.set("v.selectedLeaseAccessStatus", '');
                }
                console.log('Inside confirmStartSubmission v.selectedLeaseAccessStatus ** '+ component.get("v.selectedLeaseAccessStatus"));
                //document.getElementById('lease-header').innerHTML = 'Lease: ' + wrapper.lease.Short_Lease_Number__c;
				document.getElementById('lease-header').innerHTML = 'Lease: ' + wrapper.lease.Lease_Number__c;
                document.getElementById('lease-lessor').innerHTML = wrapper.lease.Lessor__c;
				document.getElementById('lease-effective-date').innerHTML = wrapper.lease.Lease_Effective_Date__c;
				document.getElementById('lease-expiration-date').innerHTML = wrapper.lease.Lease_Expiration_Date__c;
				document.getElementById('lease-address').innerHTML = wrapper.lease.Building_Street_Address__c;
				document.getElementById('lease-city').innerHTML = wrapper.lease.Building_City__c;
				document.getElementById('lease-state').innerHTML = wrapper.lease.Building_State_Code__c;
				document.getElementById('lease-zip-code').innerHTML = wrapper.lease.Building_Zip_Code__c;
				break;
			}
		}
		document.getElementById('confirm-create-submission').style.display = 'block';

	},
	cancelTaxSubmission: function() {
		document.getElementById('confirm-create-submission').style.display = 'none';
	},
    requestLeaseAccess: function(component, event){
        document.getElementById('confirm-create-submission').style.display = 'none';
        var leaseId = component.get("v.selectedLeaseId");
		var wrapperList = component.get("v.wrapperList");
		var wrapper;
        
        for(var i = 0; i < wrapperList.length; i++) {
			wrapper = wrapperList[i];
			if(leaseId == wrapper.lease.Id) {
                document.getElementById('lease-number').innerHTML = 'Lease: ' + wrapper.lease.Lease_Number__c;
         		document.getElementById('lease-building-name').innerHTML = wrapper.lease.Building_Name__c;
				break;
            }
        }
        document.getElementById('confirm-request-access').style.display = 'block';
    },
    cancelRequestAccess: function() {
		document.getElementById('confirm-request-access').style.display = 'none';
	},
    confirmRequestLeaseAccess: function(component) {
        this.showSpinner();
        var action = component.get("c.createLeaseAccess");
        action.setParams({ "leaseId" : component.get("v.selectedLeaseId"),
                          "ReqComments" : component.get("v.requestorComments") });

        action.setCallback(this, function(response) {
            this.hideSpinner();
   	        document.getElementById('confirm-request-access').style.display = 'none';
   	        document.getElementById('confirm-create-submission').style.display = 'none';
            var state = response.getState();
   	        var toastEvent = $A.get("e.force:showToast");
            if(component.isValid() && state === "SUCCESS") {
                toastEvent.setParams({
		        	"title": "Success!",
		        	"message": $A.get("$Label.c.RET_Lease_Access_Request_Success"),
		        	"type": "success",
		        	"duration": "10000"
		    	});
	        	toastEvent.fire();
            } else {
                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "type": "error",
                    "mode": "sticky"
                })
                toastEvent.fire();
            }
            this.findLease(component);
        });
	  	$A.enqueueAction(action); 
    },
	startTaxSubmission: function(component) {
		this.showSpinner();
		var action = component.get("c.createNewCase");
		action.setParams({ "leaseId" : component.get("v.selectedLeaseId") });
	    
	    action.setCallback(this, function(response) {
	    	this.hideSpinner();
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	var newCase = response.getReturnValue();
				var urlEvent = $A.get("e.force:navigateToURL");
    			urlEvent.setParams({
					"url": "/edit-tax-submission?id=" + newCase.Id
				});
				urlEvent.fire();

	        } else {
			    var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Error",
			        "message": response.getError()[0].message,
			        "type": "error",
			        "duration":"10000"
			    });
			    toastEvent.fire();
	        }
	    });
	    $A.enqueueAction(action);
	}
})