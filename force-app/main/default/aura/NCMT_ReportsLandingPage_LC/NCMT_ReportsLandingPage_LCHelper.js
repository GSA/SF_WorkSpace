({
  getData: function(cmp, action) {
    return new Promise($A.getCallback(function(resolve, reject){
      action.setCallback(this, function(res){

        let state = res.getState();
          resolve(res.getReturnValue());
      });
      $A.enqueueAction(action);
    }));

  },

  setReportDescription: function(projectType){
    console.log('setReportDescription ' + projectType);
    let description;
      if(projectType == 'Parametric') {// - New Construction' || projectType == 'Parametric - Repair & Alteration') {
      description = 'NCMT REPORTS'    
    } else if(projectType == 'Definitive Estimating') {
      	description = 'NCMT DES Reports';
      }
      else if(projectType == 'Cost Estimating Workbook') {
      	description = 'NCMT CEW Reports';
      }
      console.log('description = ' + description);
      return description;
  },
  getFiscalYear: function(cmp){
    var yearToday = $A.localizationService.formatDate(new Date(), "YYYY");
    var monthToday = $A.localizationService.formatDate(new Date(), "MM");
    let fiscalYears = [yearToday];
    if(monthToday > 9){
      let nextYear  = parseInt(yearToday) +1
        nextYear = nextYear.toString();
      fiscalYears.push(nextYear);

      console.log(fiscalYears, 'fiscalYears');
    }
    cmp.set('v.fiscalYears', fiscalYears );
    

  },
    
     // Code added for SFWS-2239 Block#1
      postRedirect: function(cmp, evt, hlp,reportId){
 
        var isLightning = cmp.get("v.isLightning");
        console.log("Lightning Status",isLightning);
        if(isLightning==false){
          window.parent.location = "/" + reportId + "?pv0=" + escape(cmp.get("v.projectName"));
          }
      else{
        window.location.href="/lightning/r/Report/"+ reportId + "/view?fv0="+escape(cmp.get("v.projectName"));       
        }
    }
    // End of code added for SFWS-2239 Block#1
    
    
});