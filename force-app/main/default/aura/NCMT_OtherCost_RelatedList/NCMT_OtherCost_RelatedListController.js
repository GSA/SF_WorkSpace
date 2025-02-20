({
    doInit : function(cmp, evt, hlp) {
        console.log('init other costs');
        console.log('recordId', cmp.get('v.recordId'));
        
        cmp.set('v.columns', [
            {label: 'Other Cost Number', fieldName: 'linkName', type: 'url', typeAttributes: {
                label: { fieldName: 'Name' }, target: '_parent', tooltip: 'Click for Other Cost Page' 
            },},
            {label: 'Cost Type', fieldName: 'Cost_Type__c', type: 'text'},
            {label: 'Cost Based On', fieldName: 'Cost_Based_on__c', type: 'text'},
            {label: 'Housing Plan Cost Sub-Type', fieldName: 'Housing_Plan_Cost_Sub_Type__c', type: 'text'},
            {label: 'Housing Plan Option Choice', fieldName: 'Housing_Plan_Option_Choice__c', type: 'text'}, 
            {label: 'Space Type', fieldName: 'Space_Type__c', type: 'test' },
            {label: 'Total', fieldName: 'Total1__c', type: 'number', typeAttributes: {step: '0.01', minimumFractionDigits: '2'}}
        ]);
        
        let getData = hlp.fetchData(cmp);
        getData.then(function(res){
            console.log(res);
            cmp.set('v.isMoveCostMod', res.housingPlan.Move_Cost_Module__c);
            console.log(cmp.get('v.isMoveCostMod'));
            hlp.setData(cmp, res.otherCosts, cmp.get('v.recordId'));
            console.log('projectId', cmp.get('v.projectId'));
        });
    }
})