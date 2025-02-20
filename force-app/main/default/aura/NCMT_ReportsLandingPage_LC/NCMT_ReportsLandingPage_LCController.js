({
  init: function(cmp, evt, hlp) {
    hlp.getFiscalYear(cmp);
    let getReports = cmp.get("c.getReports");
    let projectId = cmp.get("v.projectId");
    console.log("projectId", projectId);
    
          
    
    let getProject = cmp.get("c.getProjectInfo");
    getProject.setParams({ projectId: projectId });
    hlp.getData(cmp, getProject)
      .then(function(res) {
        if(res){
        cmp.set("v.projectName", res.Name);
        cmp.set("v.projectType", res.Estimate_Type_Proj__c);
        let reportDesc = hlp.setReportDescription(res.Estimate_Type_Proj__c);

        getReports.setParams({ reportDesc: reportDesc });
        }
        return hlp.getData(cmp, getReports);
      })
      .then(function(res) {
        cmp.set("v.lookupReports", res.lookupReports);
        cmp.set("v.regionReports", res.regionReports);
        cmp.set("v.projectReports", res.projectReports);        
        cmp.set("v.levelFiveUser", res.levelFiveUser);
          console.log('projectReports', res.projectReports);
      })
      .catch(function(error) {
        cmp.set("v.status", error);
      });
      
  },
    
        
  redirectToReport: function(cmp, evt, hlp) {
    var reportId = evt.currentTarget.id;
      var ret = 'Test'; 
      console.log('reportId',reportId);
    // Code added for SFWS-2239 Block#1
      let action = cmp.get("c.isLightning");
      console.log('action',action);
      action.setCallback(this,function(response){
           var state =response.getState();
           console.log('I am state',state);
            if(state==="SUCCESS"){
                console.log('This is returned',response.getReturnValue());
                cmp.set("v.isLightning",response.getReturnValue());
                console.log('Report Id',reportId);
                hlp.postRedirect(cmp,event,hlp,reportId);                   
            }
      });
         $A.enqueueAction(action);       

    // End of code added for SFWS-2239 Block#1 
  },
  redirectToProject: function(cmp, evt, hlp){        
     window.location.href = "/"+ cmp.get('v.projectId');
  },
  redirectToCustomReport: function(cmp, evt, hlp) {
    console.log(evt.currentTarget.dataset.rpt);
    let repVersionParam =
      evt.currentTarget.dataset.rpt == "repv1"
        ? "&ProjectID="
        : evt.currentTarget.dataset.rpt == "repv2"
        ? "?ProjectID="
        : null;
    let reportHref = evt.currentTarget.dataset.href;
  //window.parent.location = "/apex/" + reportHref + repVersionParam + cmp.get("v.projectName");
 // Code Added for SFWS-2212 
    window.location.href = "/apex/" + reportHref + repVersionParam + cmp.get("v.projectName");
  },
    
  redirectToFYReport: function(cmp, evt, hlp) {
    var fy = cmp.find("fiscalYearSelect").get("v.value");
    var reportId = evt.currentTarget.id;
    window.parent.location = "/" + reportId + "?pv0=" + fy;
  },
  redirectToUsersReport: function(cmp, evt, hlp) {
    let reportHref = evt.currentTarget.dataset.href;
    //window.parent.location = "/apex/" + reportHref;
    window.open("/apex/" + reportHref);
  },redirectToUsersLogReport: function(cmp, evt, hlp) {
    var days = cmp.find("numday").get("v.value");  
    let reportHref = evt.currentTarget.dataset.href;
    window.location = "/apex/" + reportHref + "?numdays=" + days;//User Log Excel fixed in Lightning-parent removed.
  },
  getSelectedProject: function(cmp, evt, hlp) {
    //get new project id from selected prohect lookip[]
    let selProjectId = cmp.get("v.project").Id;
    cmp.set("v.projectId", selProjectId);

    //reinitialize page to get correct reports for selected project type
    var reinit = cmp.get("c.init");
    $A.enqueueAction(reinit);
  }
});