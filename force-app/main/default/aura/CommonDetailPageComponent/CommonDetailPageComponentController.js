({
	doInit : function(component, event, helper) {
        var action = component.get("c.getRecordInfo");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordInfo = response.getReturnValue();
                if(recordInfo.RecordType.Name == 'AAAP'){
                    window.location = '/leasing/s/AAAP-PortalHome'
                }else{
                    window.location = '/leasing/s/RSAP-PortalHome'
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("Error message: " + errors[0].message);
                    }
                } else {
                }
            }
        });
        $A.enqueueAction(action);
	}
})