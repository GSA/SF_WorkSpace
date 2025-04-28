({
	getUrlParameter: function(sParam) {
            var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                sURLVariables = sPageURL.split('&'),
                sParameterName,
                i;

            for (i = 0; i < sURLVariables.length; i++) {
                sParameterName = sURLVariables[i].split('=');

                if (sParameterName[0] === sParam) {
                    return sParameterName[1] === undefined ? true : sParameterName[1];
                }
            }
	},
	loadPageData: function(component) {
	    // Get general page data
	    var action = component.get("c.getPageData");
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	            component.set("v.pageData", response.getReturnValue());
	            component.set("v.caseId", this.getUrlParameter('id'));
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set('v.errors', response.getError()[0].message);
                    }
                } else {
                    component.set('v.errors', $A.get("$Label.c.RET_Case_Not_Found"));
                }
	        }
	    });
	    $A.enqueueAction(action);

	    
	    // Get full list of document types
	    var action2 = component.get("c.getDocumentTypes");
	    action2.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	            component.set("v.docTypes", response.getReturnValue());
	        }
	        else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set('v.errors', response.getError()[0].message);
                    }
                } else {
                    component.set('v.errors', $A.get("$Label.c.RET_Case_Not_Found"));
                }
	        }
	    });
	    $A.enqueueAction(action2);

	    // Get case information
	    var action3 = component.get("c.getCase");
		action3.setParams({ caseId: this.getUrlParameter('id') });
	    action3.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	var taxCase = response.getReturnValue();
	            component.set("v.taxCase", taxCase);
                if(taxCase.RET_Base_Tax_Year__c != null){
	            	component.set("v.initialTaxYear", taxCase.RET_Base_Tax_Year__c);
                }
                if(taxCase.RET_Tax_County__c != null){
	            	component.set("v.initialTaxCounty", taxCase.RET_Tax_County__c);
                }
                //New code for 2024-2025 RET Surge that may handle a Lease Number passed
                //in on the URL's "Id" parameter and so need to update the caseId variable
                //to the retrieved Case record's Id
                component.set("v.caseId", taxCase.Id);
	        } else {
	            var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						component.set('v.errors', response.getError()[0].message);
                    }
                } else {
                    component.set('v.errors', $A.get("$Label.c.RET_Case_Not_Found"));
                }
	        }
	    });
	    $A.enqueueAction(action3);	    
	},
	saveCase: function(component) {
		// First make sure the year is valid.
		var taxYear = component.get("{!v.taxCase.RET_Base_Tax_Year__c}")
		if(taxYear.length != 4) {
			component.set('v.modalErrors', $A.get("$Label.c.RET_Base_Tax_Year_Wrong_Length"));
			return;
		}
		var yearIsNum = /^\d+$/.test(taxYear);
		if(yearIsNum == false) {
			component.set('v.modalErrors', $A.get("$Label.c.RET_Base_Tax_Year_Not_Numerical"));
			return;			
		}


		var action = component.get("{!c.saveCase}");
		action.setParams({ "caseToSave" : component.get("{!v.taxCase}") });
	    action.setCallback(this, function(response) {
	        
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	// save the case, set som	e messages
	        	var taxCase = response.getReturnValue();
	        	component.set('v.taxCase', taxCase);
	            component.set("v.initialTaxYear", taxCase.RET_Base_Tax_Year__c);
	            component.set("v.initialTaxCounty", taxCase.RET_Tax_County__c);
				component.set("v.modalErrors", null);
				document.getElementById('tax-edit').style.display = 'none';

			    var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Success!",
			        "message": $A.get("$Label.c.RET_Changes_Saved"),
			        "type": "success"
			    });
			    toastEvent.fire();
				
	        }
	        else {
	        	component.set('v.modalErrors', response.getError()[0].message);
	        }
	    });

	    // Send action off to be executed
	    $A.enqueueAction(action);
	},
	resetCase: function(component) {
		console.log(' ***1: ' + component.get("v.initialTaxYear"));
		component.set("v.taxCase.RET_Base_Tax_Year__c", component.get("v.initialTaxYear"));
        console.log(' ***2: ' + component.get("v.initialTaxCounty"));
		component.set("v.taxCase.RET_Tax_County__c", component.get("v.initialTaxCounty"));
		component.set("v.modalErrors", null);
		document.getElementById('tax-edit').style.display = 'none';
	},
	verifyRequiredDocuments: function(component) {
		component.set("v.submitTaxDataBtn", false);
		
		var action = component.get("{!c.validateDocuments}");
		action.setParams({ "caseToSubmit" : component.get("{!v.taxCase}") });
		
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (component.isValid() && state === "SUCCESS") {
	        	// save the case, set some messages
	        	var missingDocList = response.getReturnValue();
				if(missingDocList.length === 0) {
					document.getElementById('confirm-submission').style.display = 'block';
				} else {
					component.set("v.modalErrorTitle", 'Tax Submission - Errors Found');
					component.set("v.modalErrorBody", $A.get("$Label.c.RET_Required_Documents_Missing"));
					component.set("v.missingDocList", missingDocList);
					document.getElementById('general-messages').style.display = 'block';
				}
	        }
	        else {
	        	document.getElementById('message-header').innerHTML = 'An Error Has Occurred';
	        	document.getElementById('message-body').innerHTML = response.getError()[0].message;
	        	document.getElementById('general-messages').style.display = 'block';
	        }
	    });
	    $A.enqueueAction(action);
	},
	submitTaxData: function(component) {
		component.set("v.submitTaxDataBtn", true);
		
		var action = component.get("{!c.submitTaxCase}");
		action.setParams({ "caseToSubmit" : component.get("{!v.taxCase}") });
		
	    action.setCallback(this, function(response) {
	        
	        document.getElementById('confirm-submission').style.display = 'none';
	        var state = response.getState();
	        
	        var toastEvent = $A.get("e.force:showToast");
	        if (component.isValid() && state === "SUCCESS") {
		    	toastEvent.setParams({
		        	"title": "Success!",
		        	"message": $A.get("$Label.c.RET_Tax_Submission_Success"),
		        	"type": "success",
		        	"duration": "10000"
		    	});
	        	toastEvent.fire();
	        }
	        else {
			    toastEvent.setParams({
			        "title": "Error",
			        "message": response.getError()[0].message,
			        "type": "error",
			        "mode": "sticky"
			    });
	        }
	        toastEvent.fire();

	    });
	    $A.enqueueAction(action);

	}
})