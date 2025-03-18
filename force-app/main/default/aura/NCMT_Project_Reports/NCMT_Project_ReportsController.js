({
    doInit : function(cmp, evt, hlp) {
        
        var sanitizeParams = hlp.sanitizeParams(cmp);
        sanitizeParams.then(function(res){
            cmp.set('v.safeReportType', res.cleanReportType);
            var reportVar = res.cleanReportType.slice(0, -1)
            
            cmp.set('v.reportVar', reportVar );
            cmp.set('v.safeCategoriesReport', res.cleanCategoriesReport);

        });
        var today = $A.localizationService.formatDate(new Date(), "MM/d/YYYY");
        cmp.set('v.today', today);
        let getData = hlp.fetchData(cmp);
        
        getData.then(function(res){
            console.log(res.markup);
            cmp.set('v.markup', res.markup);
            

            //get markups percentages
            console.log('markuppctnts pre loop', res.markup);

            var markuppctnts = Object.assign({}, res.markup);

            
            for(var key in markuppctnts){
                markuppctnts[key] = markuppctnts[key]/100;

            };
            console.log('markuppctnts post loop', markuppctnts);

            
            cmp.set('v.markuppctnts', markuppctnts);
            var isOandP = (res.project.Markup_Method__c == 'RSMeans - O&P');
            cmp.set('v.isOandP', isOandP);
            cmp.set('v.treeValues', res.treeValues);
            cmp.set('v.trees', res.trees);

            
            hlp.formatTreesAndItems(cmp, res.treeValues);
            res.project.Basis_Date_Of_Estimate__c = $A.localizationService.formatDate(res.project.Basis_Date_Of_Estimate__c, "MM/d/YYYY");
            res.project.CreatedDate = $A.localizationService.formatDate(res.project.CreatedDate, "MM/d/YYYY");
            res.project.Mid_Point_of_Construction__c  = $A.localizationService.formatDate(res.project.Mid_Point_of_Construction__c , "MM/d/YYYY");

            res.project.indexLocation =  res.project.Location__r.City__c + ', '+  res.project.Location__r.State__c;
            res.project.location =  res.project.City__c + ', '+  res.project.State__c;
            cmp.set('v.project', res.project);


        
    });
        
    },
    redirectToProject: function(cmp, evt, hlp){        
        window.location.href = "/"+ cmp.get('v.recordId');
    },
    
     funPrint: function(component, event, helper){
        document.getElementById('prnBtn').style.display='none';  
        window.print();
        document.getElementById('prnBtn').style.display='block'; 
    }
   })