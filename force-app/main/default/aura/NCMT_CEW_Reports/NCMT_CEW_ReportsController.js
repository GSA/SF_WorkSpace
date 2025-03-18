({ 
     init : function(cmp, evt, hlp){
        cmp.set('v.today', $A.localizationService.formatDate(new Date(), "MM/d/YYYY"));
        let projectId = cmp.get('v.recordId'); 
        if(cmp.get('v.reportType') == 'FBF_RWA_FUNDING'){
            cmp.set('v.pageTitle', 'ASTM Uniformat Sum - Total' );
        }else if(cmp.get('v.reportType') == 'PBS_RWA'){
            cmp.set('v.pageTitle', 'ETPC - Total (FBF & RWA)' );
        }else if(cmp.get('v.reportType') == 'CEW_Summary'){
            cmp.set('v.pageTitle', 'CEW Summary Report' );

        }
        hlp.getData(cmp, projectId)
        .then(function(res){
            console.log('res', res);
            cmp.set('v.pcs', res.pcs);
            cmp.set('v.proServEst',  res.proServEst);
            hlp.formatMarkups(cmp, res.project, res.proServEst);
            hlp.calculateWorkDecTotals(cmp, res.workDescTotals, res.rwaDirectCost);

        });
    },
    funPrint: function(component, event, helper){
      document.getElementById('prnBtn').style.display='none';  
      window.print();
      document.getElementById('prnBtn').style.display='block'; 
   },
   redirectToProject: function(cmp, evt, hlp){        
      parent.window.location.href = "/"+ cmp.get('v.recordId');
    },

 })