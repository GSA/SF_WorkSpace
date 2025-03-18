({
    retrieveOptions : function(component, event, helper) {
        var recordType = component.get('v.templateRecordType');
        var templateType = component.get('v.templateType');
        var projId = component.get('v.id');
        console.log(component.get('v.idHP'));
        let optData = component.get('c.retrieveOptions');
        //String recordType, String type, String housingPlanId
        optData.setParams({
            "recordType" : recordType,
            "templateType" : templateType,
            "projId" : projId
        });
        console.log('retrieve', recordType, templateType, projId);
        optData.setCallback(this, function(response){
            var state = response.getState();
            //console.log('templateType == ' +templateType +' callback....' +state +' ' +component.isValid());
            if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                var opts = response.getReturnValue();
               
                console.log('successful retrieve', opts);
                component.set('v.typeOptions', opts);
                component.set('v.isLoaded', true);
                
                
            }else if(state==='INCOMPLETE'){
                console.log(JSON.stringify(response.getError()));
            }else if(state ==='ERROR'){
                console.log(response.getError());
            }else{
                
            }
            component.set('v.isLoaded', true);
        });

        $A.enqueueAction(optData);
    },
    saveOptions : function(component, event, helper) {
        component.set('v.isLoaded', false);
        component.set('v.isSaved', false);
        component.set('v.saveError', null);
        var opts = component.get('v.typeOptions');
       
        let saveOpts = component.get('c.saveHousingPlanOpts');
        //String recordType, String type, String housingPlanId
        saveOpts.setParams({
            "opts" : opts
        });
        saveOpts.setCallback(this, function(response){
            var state = response.getState();
           
            if(component.isValid() && (state === 'SUCCESS' || state === 'DRAFT')){
                var res = response.getReturnValue();

                
                console.log('save response == ' + res);
                // "variant": (res == null ? 'info' : 'error'),
                component.set('v.isSaved', (res == null ? true : false));
                component.set('v.saveError', res);

                if (res == null ){
                    var url = window.location.href;
                    setTimeout(window.location = url, 3000);
                }
            }else if(state==='INCOMPLETE'){
                component.set('v.saveError', JSON.stringify(response.getError()));
            }else if(state ==='ERROR'){
                console.log(response.getError());
                component.set('v.saveError', response.getError());
               
            }else{
                
            }
            component.set('v.isLoaded', true);
        });

        $A.enqueueAction(saveOpts);
    }
})