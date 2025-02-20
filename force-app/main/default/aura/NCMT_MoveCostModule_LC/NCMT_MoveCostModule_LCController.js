({
    doInit : function(cmp, evt, hlp) {
        console.log('init MoveCostModule');
        
        /*var actions = [
            { label: 'Add Housing Plan', name: 'add' },
            { label: 'Manage Moving Costs', name: 'manageMC' },
            { label: 'Project Moving Costs Report', name: 'report'}
        ];*/
        var actions = hlp.getRowActions.bind(this, cmp);
        
        cmp.set('v.columns', [
            /*{label: 'Name', fieldName: 'linkName', type: 'url', 
             typeAttributes: {label: { fieldName: 'Name' }, target: '_parent'}
             },*/
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Total', fieldName: 'Other_Costs_Total', type: 'currency',  
             typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2},
             cellAttributes: {alignment: 'left'}},
            { label: '', type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        let getData = hlp.fetchData(cmp);
        getData.then(function(res){
            console.log('res', res);
            cmp.set('v.reportId', res.reportId);
            cmp.set('v.redirectProjName', res.redirectProjName);
            cmp.set('v.redirectMCM', res.redirectMoveCostMod);
            hlp.setData(cmp, res.projList, res.otherCosts);
        });
    },
    
    save : function(cmp, evt, hlp) {
        
        var projName = cmp.get('v.projName');
        var projURL = cmp.get('v.redirectProjName');
        var mcmURL = cmp.get('v.redirectMCM');
        let getProj = hlp.createProj(cmp, projName);
        getProj.then(function(res){
            console.log('res', res);
            cmp.set('v.proj', res);
            cmp.set('v.projId', res.Id);
            var projId = res.Id.substring(0,15);
            
            let action3 = cmp.get("c.isLightning");
            if(action3==false){
                window.location.href = '/a1C/e?'+projURL+'='+projName+'&'+mcmURL+'=1&nooverride=1'; 
                console.log("I'm classic");
            }
            else{          
                window.location.href = '/lightning/o/NCMT_Housing_Plan__c/new?defaultFieldValues=Project__c='+projId+',Move_Cost_Module__c=true&nooverride=1'; 
                console.log("I'm lightning"); 
            }            
        });        
    },
    
    cancel : function(cmp, evt, hlp) {
        window.location.href = '/apex/NCMT_MoveCostModule_LC';
    },
    
    handleNew : function(cmp, evt, hlp) {
        cmp.set('v.isNew', true);
    },
    
    handleAction : function(cmp, evt, hlp) {
        //url fields
        var projURL = cmp.get('v.redirectProjName');
        var mcmURL = cmp.get('v.redirectMCM');
        console.log('projURL',projURL);
        console.log('mcmURL',mcmURL);
        console.log('action!');
        var action = evt.getParam('action');
        var row = evt.getParam('row');
        var rowObj = JSON.stringify(row);
        rowObj = JSON.parse(rowObj);
        console.log("test",rowObj);
        var projId=rowObj.Id;
        
        var projName = rowObj.Name;
        console.log("project name",projName);
        var reportId = cmp.get('v.reportId');
        console.log(action.name);
        
        switch (action.name) {
            case 'add':
                let action = cmp.get("c.isLightning");
                console.log('action',action);
                action.setCallback(this,function(response){
                    var state =response.getState();
                    console.log('I am state',state);
                    if(state==="SUCCESS"){
                        console.log('This is returned',response.getReturnValue());
                        cmp.set("v.isLightning",response.getReturnValue());
                        console.log('Report Id',reportId);
                        hlp.postMoveRedirect(cmp,event,hlp,projName,projId,projURL,mcmURL);                   
                    }
                });
                $A.enqueueAction(action);                  
                break;
                
            case 'manageMC':
                var moveCostURL = '/apex/NCMT_HousingPlan_OptionSelection?id='+rowObj.Id
                +'&templateType=Moving+Costs&recordType=Other_Cost&isHP=1';
                window.location.href = moveCostURL;                
                break;
                
            case 'report':               
                //Code added for Project Moving Cost report Block#1
                let action2 = cmp.get("c.isLightning");
                console.log('action',action2);
                action2.setCallback(this,function(response){
                    var state =response.getState();
                    console.log('I am state',state);
                    if(state==="SUCCESS"){
                        console.log('This is returned',response.getReturnValue());
                        cmp.set("v.isLightning",response.getReturnValue());
                        console.log('Report Id',reportId);
                        hlp.postRedirect(cmp,event,hlp,reportId,projName);                   
                    }
                });
                $A.enqueueAction(action2);                       
                break;
                
            case 'edit':
                window.location.href = '/' + rowObj.Id + '/e';
            case 'view':
                window.location.href = '/'+rowObj.Id;
                
        }
    }
})