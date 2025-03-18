({
    doInit : function(cmp, evt, hlp) {
        cmp.set('v.deliverables', []);
        cmp.set('v.processing', false);
        var today = $A.localizationService.formatDate(new Date(), "MM/d/YYYY");
        cmp.set('v.today', today);
        cmp.set('v.filterDeliverable', {Funding_Type__c: null, sobjectType: 'NCMT_Project_Deliverable__c'});

        let getData = hlp.fetchData(cmp);
        
        getData.then(function(res){
            cmp.set('v.project', res.project);
            console.log(cmp.get('v.filterDeliverable'));
            cmp.set('v.filterDeliverable', res.filterDeliverable);
            console.log(res.filterDeliverable);
            console.log(cmp.get('v.filterDeliverable'));
            //Populate filters passed in from print option
            if (cmp.get('v.urlFunding') != null &&cmp.get('v.urlFunding') != '')
                cmp.set('v.filterDeliverable.Funding_Type__c', unescape(cmp.get('v.urlFunding')));
            
            if (cmp.get('v.urlType') != null &&cmp.get('v.urlType') != '')
                cmp.set('v.filterDeliverable.Project_type__c', unescape(cmp.get('v.urlType')));
            
            if (cmp.get('v.urlDeliv') != null &&cmp.get('v.urlDeliv') != '')
                cmp.set('v.filterDeliverable.Project_Delivery_Method__c', unescape(cmp.get('v.urlDeliv')));
            
            if (cmp.get('v.urlBudget') != null &&cmp.get('v.urlBudget') != '')
                cmp.set('v.filterDeliverable.Project_Budget__c', unescape(cmp.get('v.urlBudget')));
            
            console.log('I am initing' +cmp.get('v.printMode'));
            if (cmp.get('v.filterDeliverable.Funding_Type__c') != null 
                &&cmp.get('v.filterDeliverable.Funding_Type__c') != ''
                &&cmp.get('v.filterDeliverable.Project_type__c') != null 
                &&cmp.get('v.filterDeliverable.Project_type__c') != ''
                &&cmp.get('v.filterDeliverable.Project_Delivery_Method__c') != null 
                &&cmp.get('v.filterDeliverable.Project_Delivery_Method__c') != ''
                &&cmp.get('v.filterDeliverable.Project_Budget__c') != null 
                &&cmp.get('v.filterDeliverable.Project_Budget__c') != ''
            ){
                let getDeliv = hlp.fetchDeliverables(cmp);
                getDeliv.then(function(res){
                    cmp.set('v.deliverables', res);
                    cmp.set('v.processing', false);
                    
                });
                
            }



            
        });
        
    },

    handleFilter : function(cmp, evt, hlp) {
        evt.preventDefault();
        cmp.set('v.processing', true);
        let getData = hlp.fetchDeliverables(cmp);
        getData.then(function(res){
            cmp.set('v.deliverables', res);
            cmp.set('v.processing', false);
        });
    },
    printMe: function(cmp){
        var projId = cmp.get('v.project.Id');
        if (projId != null &&projId != ''){
            window.open('apex/NCMT_Risk_Triage_Tool_VF?print=true&id=' +projId,
                        '_new'
                        );
        } else {
            var funding = encodeURI(cmp.get('v.filterDeliverable.Funding_Type__c'));
            var pType = encodeURI(cmp.get('v.filterDeliverable.Project_type__c'));
            var deliv = encodeURI(cmp.get('v.filterDeliverable.Project_Delivery_Method__c'));
            var budget = encodeURI(cmp.get('v.filterDeliverable.Project_Budget__c'));
            
            window.open('apex/NCMT_Risk_Triage_Tool_VF?print=true&funding=' +funding 
                                +'&type=' +pType +'&deliv=' +deliv +'&budget=' +budget,
                        '_new'
                        );
        }
    },
    
    funPrint: function(component, event){
        document.getElementById('prnBtn').style.display='none';  
        window.print();
        document.getElementById('prnBtn').style.display='block'; 
    }
})