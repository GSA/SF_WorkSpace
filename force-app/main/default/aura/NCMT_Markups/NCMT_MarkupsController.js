({
    doInit : function(cmp, evt, hlp) {
        let getData = hlp.fetchData(cmp);
        getData.then(function(res){
            cmp.set('v.project', res.project);
            var isOandP = (res.project.Project_Name__r.Markup_Method__c == 'RSMeans - O&P');
            cmp.set('v.isOandP', isOandP);
            
      });        
    },
    handleOnSuccess : function(component, event, helper) {
       //component.set("v.reloadForm", false);
       //component.set("v.reloadForm", true);
        var myEvent = $A.get("e.c:NCMT_SendDataToVFPage");
        myEvent.fire();
    },
    handleOnSubmit : function(component, event, helper) {
        console.log('submit!');
        event.preventDefault(); 
        //if(!component.get("v.isExclconChanged") && !component.get("v.isDesignSiteChanged")){
          var eventFields = event.getParam("fields");
          component.find('form').submit(eventFields);
            
        //}
    },
    handleOnload : function(component, event, helper) {
       component.set("v.showSpinner", false);
    },
    handleOnError : function(component, event, helper) {
         
    },
    handleOnChangeExclCons: function (component, event, helper) {
        if(event.getSource().get("v.value")==true){
        	component.set("v.isExclconChanged", true);
            component.find("constcontg").set("v.value",0);
        }else{
            component.find("constcontg").set("v.value",7);
        }
                
    },
    handleOnChangeDesignSite: function (component, event, helper) {
          component.set("v.isDesignSiteChanged", true);
    },
    handleOnChangeComments: function (component, event, helper) {
        component.set("v.isDesignSiteChanged", false);
        component.set("v.isExclconChanged", false);
    },
    handleOnChangeAia: function (component, event, helper) {
        if(event.getSource().get("v.value")==true){
            component.find("aia").set("v.value",0.5);
        }else{
            component.find("aia").set("v.value",0);
        }
                
    }
})