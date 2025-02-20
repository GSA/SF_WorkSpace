({
	doInit : function(cmp, evt, hlp) {
        let getData = hlp.fetchData(cmp);
        getData.then(function(res){
            cmp.set('v.project', res.project);
            var markupMethod = res.project.Markup_Method__c;
            var isOandP = (res.project.Markup_Method__c == 'RSMeans - O&P');
            cmp.set('v.isOandP', isOandP);
            
            
            var columns = [
               {
                    label: 'Markup ID',
                    type: 'url',
                    fieldName: 'linkName',
                    typeAttributes: {
                        label: { fieldName: 'Name' }, target: '_parent', tooltip: 'Click for Project Markup' 
                    },
                 // initialWidth: 120   
                    initialWidth: 200                    
                }
                ];
            
                 if(!isOandP){ 
                	columns.push({
                    type: 'percentage',
                    fieldName: 'Site_Design_Contingency__c',
                 // initialWidth: 220        
                    initialWidth: 400,
                    label: 'Site & Design Contingency'
                	})
            	};
                columns.push({
                    type: 'percentage',
                    fieldName: 'Construction_Contingency__c',
                 // initialWidth: 220   
                    initialWidth: 400,
                    label: 'Construction Contingency'
                 })
                if(!isOandP){ 
                	columns.push({
                    type: 'percentage',
                    fieldName: 'Art_In_Architecture__c',
                    initialWidth: 800,
                    label: 'Art In Architecture'
                 })
            	};

            /*
             *  Below Lines has been commented out as a fix to SFWS-2014 on Nov 8,2022
             * /
            
           /*     columns.push({
                    type: 'currency',
                    fieldName: 'ECCA__c',
                    label: 'ECCA'
                 },
                {
                    type: 'currency',
                    fieldName: 'ECC__c',
                    label: 'ECC'
                 })                
            
            if(!isOandP){ 
                columns.push({
                type: 'currency',
                //initialWidth: 100,
                fieldName: 'ETPC__c',
                label: 'ETPC',
                })
            };*/
            cmp.set('v.columns', columns); 
            hlp.setData(cmp, res.projectMP);
                
        });        
    }
})