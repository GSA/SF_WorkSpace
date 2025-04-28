public with sharing class PBS_gBUILD_ProjectsController extends PBS_gBUILD_PageBaseController 
{
    public String paramProjectId { get; set; }
    public String paramPbsProjectId { get; set; }
    public list<ProjectWrapper> projects { get; private set;}  
    private map<string, string> pregions {get;set;}
    private map<string, string> ptypes {get;set;}
    public list<string> pregionslist {get;set;}
    public list<string> pstatuslist{get;set;}
    public list<string> ptypeslist {get;set;}
    public list<string> ppgmfullcodelist {get;set;}
    public string qs {get;set;}
    public boolean firstLoad = false;
    public string fordb{get;set;}
    public String soql {
    get {
        soql = 'select id, Name, BudgetActivityCode__c, ProjectType__c, ProjectId__c, ProjectId__r.txtCreatedIn__c, '+
                       'ProjectId__r.txtCurrentState__c, ProjectId__r.txtProjectManager__c, ProjectID__r.numProjectNumber__c,ProjectId__r.txtProgram__c, '+
                       'ProjectId__r.txtProgramArea_FullCode__c, ProjectId__r.txtLongName__c,ProjectId__r.txtRegion__c, WorkflowPhaseId__r.Label__c, ' +
                       'LastModifiedDate from PBS_gBUILD_Project__c where ProjectId__r.txtCurrentState__c NOT IN (null) and ProjectId__c != null';
        return soql; 
        }
    set;
    } 
        
  public String userInfoID{
      get{
          userInfoID = UserInfo.getuserid();          
          return userInfoID;}set;
  }

  public String sortDir {
    get{ 
        if (sortDir == null){
            sortDir = 'asc'; 
        } 
        return sortDir;  } set;
    }
  
  public String sortField{
    get{ 
        if (sortField == null) 
        {
            sortField = 'name'; 
        } 
        return sortField;  } set;
    }

  public String debugSoql {
    get { 
        return soql + ' order by ' + sortField + ' ' + sortDir + ' limit ' + PBS_gBUILD_Utility.soqlLimit; } set;
    }
  
  public boolean portalUser {
      get{
          try{
          return isCustomerPortalUser;}catch(NullPointerException e){}return false;} set;
        }

    
  public boolean viewAllProjectsPortalAccount{
      get{
          try{
              return isViewAllProjectsCustomerPortalAccount;}catch(NullPointerException e){}return false;} set;
        }
      
    public ApexPages.StandardSetController conProject 
    {
        get {
            if(conProject == null){ 
               if(!portalUser || viewAllProjectsPortalAccount){
                        conProject = new ApexPages.StandardSetController(Database.query(soql +
                                     ' order by lastmodifieddate desc limit 500'));
               }
              else{         
                        conProject = new ApexPages.StandardSetController(Database.query(soql +   ' and ('
                             +'(CpEditor1__c=:CustomerPortalContactId) OR '
                             +'(CpEditor2__c=:CustomerPortalContactId) OR '
                             +'(CpEditor3__c=:CustomerPortalContactId) OR '
                             +'(CpEditor4__c=:CustomerPortalContactId) OR '
                             +'(CpEditor5__c=:CustomerPortalContactId) OR '
                             +'(CpEditor6__c=:CustomerPortalContactId) OR '
                             +'(CpEditor7__c=:CustomerPortalContactId) OR '
                             +'(CpEditor8__c=:CustomerPortalContactId) OR '
                             +'(CpEditor9__c=:CustomerPortalContactId) OR '
                             +'(CpEditor10__c=:CustomerPortalContactId) OR '
                             +'(CpViewer1__c=:CustomerPortalContactId) OR '
                             +'(CpViewer2__c=:CustomerPortalContactId) OR '
                             +'(CpViewer3__c=:CustomerPortalContactId) OR '
                             +'(CpViewer4__c=:CustomerPortalContactId) OR '
                             +'(CpViewer5__c=:CustomerPortalContactId) OR '
                             +'(CpViewer6__c=:CustomerPortalContactId) OR '
                             +'(CpViewer7__c=:CustomerPortalContactId) OR '
                             +'(CpViewer8__c=:CustomerPortalContactId) OR '
                             +'(CpViewer9__c=:CustomerPortalContactId) OR '
                             +'(CpViewer10__c=:CustomerPortalContactId) OR '
                             +'(OwnerId=:userInfoID))'
                             + ' order by lastmodifieddate desc'
                             +' limit 500'));   
                }
                conProject.setPageSize(PBS_gBUILD_Utility.soqlLimit);
            }      
            return conProject;
        }
        set;
    }
    
    public String querystring {
        get{if (qs==null) 
            return soql; 
         else return qs; } set;
    }
    
        public void runQuery()
        {
               if(!portalUser || viewAllProjectsPortalAccount) 
                {
                        conProject = new ApexPages.StandardSetController(Database.query(querystring 
                        + ' order by lastmodifieddate desc limit 500'));    
                }
               else
                {     
                    conProject = new ApexPages.StandardSetController(Database.query(querystring +  ' and ('
                         +' CpEditor1__c=:CustomerPortalContactId OR'
                         +' CpEditor2__c=:CustomerPortalContactId OR'
                         +' CpEditor3__c=:CustomerPortalContactId OR'
                         +' CpEditor4__c=:CustomerPortalContactId OR'
                         +' CpEditor5__c=:CustomerPortalContactId OR'
                         +' CpEditor6__c=:CustomerPortalContactId OR'
                         +' CpEditor7__c=:CustomerPortalContactId OR'
                         +' CpEditor8__c=:CustomerPortalContactId OR'
                         +' CpEditor9__c=:CustomerPortalContactId OR'
                         +' CpEditor10__c=:CustomerPortalContactId OR'
                         +' CpViewer1__c=:CustomerPortalContactId OR'
                         +' CpViewer2__c=:CustomerPortalContactId OR'
                         +' CpViewer3__c=:CustomerPortalContactId OR'
                         +' CpViewer4__c=:CustomerPortalContactId OR'
                         +' CpViewer5__c=:CustomerPortalContactId OR'
                         +' CpViewer6__c=:CustomerPortalContactId OR'
                         +' CpViewer7__c=:CustomerPortalContactId OR'
                         +' CpViewer8__c=:CustomerPortalContactId OR'
                         +' CpViewer9__c=:CustomerPortalContactId OR'
                         +' CpViewer10__c=:CustomerPortalContactId OR'
                         +' OwnerId=:userInfoID'
                         +') '
                         + ' order by lastmodifieddate desc '
                         +' limit 500'));
                }
          }
          
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    }
    
    public PBS_gBUILD_ProjectsController()
    {
        super();
        PBS_gBUILD_CookieHelper ch = new PBS_gBUILD_CookieHelper();
        ch.resetProjectCookies();
        ch.setPageName(null);
        ch.setExtraBreadcrumbs(null);       
        ch.setCookies();       
        PBS_gBUILD_Project__c project;
        
        pregionslist = new list<string>();
        ptypeslist = new list<string>();
        pstatuslist = new list<string>();
        ppgmfullcodelist = new list<string>();
        
        qs = null;       
                     
        map<string, List<string>> buildingIdsByPbsProjectId = new map<string, List<string>>();
       
        for (PBS_gBUILD_Project__c p : (List<PBS_gBUILD_Project__c>)conProject.getRecords())
        {
            buildingIdsByPbsProjectId.put(p.ProjectId__c, new List<string>());
        }       
        
      Schema.sObjectType objType = PBS_gBUILD_Project__c.getSObjectType(); 
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
      list<Schema.PicklistEntry> values = fieldMap.get('ProjectType__c').getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : values)
      { 
         ptypeslist.add(a.getlabel());
      } 
      Schema.sObjectType pbsproject = PBS_Project__c.getSObjectType(); 
      Schema.DescribeSObjectResult pbsDescribe=pbsproject.getDescribe();       
      map<String, Schema.SObjectField> pbsfieldmap = pbsDescribe.fields.getMap(); 
      list<Schema.PicklistEntry> pbsvalues=pbsfieldmap.get('txtRegion__c').getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : pbsvalues) 
      { 
       //  Integer ti = Integer.valueof(a.getlabel()); 
         pregionslist.add(a.getLabel()); 
      }
      list<Schema.PicklistEntry> statusvalues=pbsfieldmap .get('txtCurrentState__c').getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : statusvalues)
      {         
         pstatuslist.add(a.getlabel());
      }
      list<Schema.PicklistEntry> pgmvalues=pbsfieldmap .get('txtProgramArea_FullCode__c').getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : pgmvalues)
      {         
         ppgmfullcodelist.add(a.getlabel());
      }
        ptypeslist.sort();    
        pstatuslist.sort();
        ppgmfullcodelist.sort();
        
        for (PBS_BuildingProjectAssociation__c pba :
        [
            select rluProject__c, rluBuilding__r.Location_Code_Plus__c
            from PBS_BuildingProjectAssociation__c
            where rluProject__c in :buildingIdsByPbsProjectId.keySet()
        ])
        {
            buildingIdsByPbsProjectId.get(pba.rluProject__c).add(pba.rluBuilding__r.Location_Code_Plus__c);
        }

         projects = new List<ProjectWrapper>();
        for (PBS_gBUILD_Project__c p : (List<PBS_gBUILD_Project__c>)conProject.getRecords())
        {
            ProjectWrapper pw = new ProjectWrapper(p);
            projects.add(pw);
            if (buildingIdsByPbsProjectId.containsKey(p.ProjectId__c))
            {
                pw.BuildingLocationCodes = buildingIdsByPbsProjectId.get(p.ProjectId__c);
            }
        }
        super.bind();
    }
    
    public String projectId{
         get{
            try{
                return Apexpages.currentPage().getParameters().get('projectId').trim();
            }catch(NullPointerException e){ }
             return '';
         }
            set;
     }
    public String projectIdQS(){
            if (projectId != ''){
               //SGanti commented out 3/2022 SFWS_1700
                // return ' and name like \'%' + projectId + '%\'';}  
        //SGanti added 3/2022 SFWS_1700
                return ' and name like \'%' + String.escapeSingleQuotes(projectId) + '%\'';}    
        return '';
    }
    public String projectNameQS(){
         if (projectName != ''){
           return ' and ProjectId__r.txtLongName__c like \'%' + String.escapeSingleQuotes(projectName) + '%\''; }
        return '';
    }
     public String projectTypes{
         get{
            try{
                return Apexpages.currentPage().getParameters().get('projectType').trim();
            }catch(NullPointerException e){ }
             return '';}
            set;
     }
    public String projectTypesQS(){
            if (projectTypes != ''){
         //SGanti commented out 3/2022 SFWS_1700 
                //      return ' and ProjectType__c like \'%' + projectTypes + '%\'';}
        //SGanti added 3/2022 SFWS_1700
                return ' and ProjectType__c like \'%' + String.escapeSingleQuotes(projectTypes) + '%\'';}  
        return '';
    }
     public String projectRegions{
         get{
            try{
                return Apexpages.currentPage().getParameters().get('projectRegion').trim();
            }catch(NullPointerException e){ }
             return '';
         }
            set;
     }
    public String projectRegionsQS(){
            if (projectRegions != ''){
                         //SGanti commented out 3/2022 SFWS_1700 
                //return ' and ProjectId__r.txtRegion__c = \'' + projectRegions + '\''; }    
             //SGanti added 3/2022 SFWS_1700
                return ' and ProjectId__r.txtRegion__c = \'' + String.escapeSingleQuotes(projectRegions) + '\''; }    
        return '';
    }
    
    public String pgmFullCodes{
         get{
            try{
                return Apexpages.currentPage().getParameters().get('programFullCode').trim();
            }catch(NullPointerException e){ }
             return '';
         }
            set;
     }
    public String pgmFullCodesQS(){
            if (pgmFullCodes != ''){
                //SGanti commented out 3/2022 SFWS_1700 
                //return ' and ProjectId__r.txtProgramArea_FullCode__c = \'' + pgmFullCodes + '\''; }
                //SGanti added 3/2022 SFWS_1700
  
        return ' and ProjectId__r.txtProgramArea_FullCode__c = \'' + String.escapeSingleQuotes(pgmFullCodes) + '\''; } 
        return '';
    }
    
    public String projectManagers{
         get{
            try{
                return Apexpages.currentPage().getParameters().get('projectManager').trim();
            }catch(NullPointerException e){ }
             return '';
         }
            set;
     }
    public String projectManagersQS(){
            if (projectManagers != ''){
                return ' and ProjectId__r.txtProjectManager__c like \'%' + String.escapeSingleQuotes(projectManagers) + '%\''; }    
        return '';
    }
    public String projectBACode{
        get{
        try{
            return Apexpages.currentPage().getParameters().get('baCode').trim();
        }catch(NullPointerException e) {} 
            return '';
        }set;
    }
    public String BACodeQS(){       
        if (projectBACode != ''){
            //SGanti commented out 3/2022 SFWS_1700    
            // return ' and BudgetActivityCode__c like \'%' + projectBACode + '%\'';}
            //SGanti added 3/2022 SFWS_1700
         return ' and BudgetActivityCode__c like \'%' + String.escapeSingleQuotes(projectBACode) + '%\'';}      
        return '';
    }
    public String status{
        get{try{
            return Apexpages.currentPage().getParameters().get('status').trim();
        }catch(NullPointerException e){} 
            return ''; 
        }set;
    }
    public String statusQS(){
        if (status != ''){
                        //SGanti commented out 3/2022 SFWS_1700    
            //return ' and ProjectId__r.txtCurrentState__c =\'' + status + '\''; }
            //SGanti added 3/2022 SFWS_1700
            return ' and ProjectId__r.txtCurrentState__c =\'' + String.escapeSingleQuotes(status) + '\''; }
        return '';
    }
    public void filterProjects(){
        qs = 'select id, Name, BudgetActivityCode__c, ProjectType__c, ProjectId__c, ProjectId__r.txtCreatedIn__c, '+
            'ProjectId__r.txtCurrentState__c, ProjectId__r.txtProjectManager__c, ProjectID__r.numProjectNumber__c, ProjectId__r.txtProgram__c, '+
            'ProjectId__r.txtProgramArea_FullCode__c, ProjectId__r.txtLongName__c,ProjectId__r.txtRegion__c, ' + 
            'WorkflowPhaseId__r.Label__c, LastModifiedDate from PBS_gBUILD_Project__c' + 
            ' where ProjectId__r.txtCurrentState__c != \'Cancelled\' and ProjectId__c != null' 
            +projectIdQS() +projectNameQS()+projectTypesQS()+projectRegionsQS()+projectManagersQS()+pgmFullCodesQS();
        
        ShowDebugMessage('Query String is '+qs);
        
         list<id> buildingprojects = new list<id>();
         if (projectBuilding != ''){
         //SGanti commented out 3/2022 SFWS_1700    
         // for (PBS_BuildingProjectAssociation__c pba :(List<PBS_BuildingProjectAssociation__c >)Database.query('select rluProject__c from PBS_BuildingProjectAssociation__c where rluBuilding__r.Location_Code_Plus__c like \'%' + projectBuilding + '%\'')){
         //SGanti added 3/2022 SFWS_1700
             for (PBS_BuildingProjectAssociation__c pba :(List<PBS_BuildingProjectAssociation__c >)Database.query('select rluProject__c from PBS_BuildingProjectAssociation__c where rluBuilding__r.Location_Code_Plus__c like \'%' + String.escapeSingleQuotes(projectBuilding) + '%\'')){   
             buildingprojects.add(pba.rluProject__c);} qs += ' and projectid__c in :buildingprojects';}   

        try{
            qs += BACodeQS() + statusQS();}catch(NullPointerException e){}
        
       map<string, List<string>> buildingIdsByPbsProjectId = new map<string, List<string>>();       
       if(!portalUser || viewAllProjectsPortalAccount) 
       {
                conProject = new ApexPages.StandardSetController(Database.query(qs 
                + ' order by lastmodifieddate desc limit 500'));
                fordb = '1';  
        } else
        {
                conProject = new ApexPages.StandardSetController(Database.query(qs + ' and ('
                     +'CpEditor1__c=:CustomerPortalContactId or '
                     +'CpEditor2__c=:CustomerPortalContactId or '
                     +'CpEditor3__c=:CustomerPortalContactId or '
                     +' CpEditor4__c=:CustomerPortalContactId or'
                     +' CpEditor5__c=:CustomerPortalContactId or'
                     +' CpEditor6__c=:CustomerPortalContactId or'
                     +' CpEditor7__c=:CustomerPortalContactId or'
                     +' CpEditor8__c=:CustomerPortalContactId or'
                     +' CpEditor9__c=:CustomerPortalContactId or'
                     +' CpEditor10__c=:CustomerPortalContactId or'
                     +'CpViewer1__c=:CustomerPortalContactId or '
                     +'CpViewer2__c=:CustomerPortalContactId or '
                     +'CpViewer3__c=:CustomerPortalContactId or '
                     +' CpViewer4__c=:CustomerPortalContactId or'
                     +' CpViewer5__c=:CustomerPortalContactId or'
                     +' CpViewer6__c=:CustomerPortalContactId or'
                     +' CpViewer7__c=:CustomerPortalContactId or'
                     +' CpViewer8__c=:CustomerPortalContactId or'
                     +' CpViewer9__c=:CustomerPortalContactId or'
                     +' CpViewer10__c=:CustomerPortalContactId or'
                     +'OwnerId=:userInfoID '
                     +') '
                     + ' order by lastmodifieddate desc '
                     +'limit 500'));
        }           
        conProject.setPageSize(PBS_gBUILD_Utility.soqlLimit);
                
        for (PBS_gBUILD_Project__c p : (List<PBS_gBUILD_Project__c>)conProject.getRecords())
        { buildingIdsByPbsProjectId.put(p.ProjectId__c, new List<string>());
        }
        
        for (PBS_BuildingProjectAssociation__c pba :
        [
            select rluProject__c, rluBuilding__r.Location_Code_Plus__c
            from PBS_BuildingProjectAssociation__c
            where rluProject__c in :buildingIdsByPbsProjectId.keySet()
        ])
        { buildingIdsByPbsProjectId.get(pba.rluProject__c).add(pba.rluBuilding__r.Location_Code_Plus__c);
        }
         projects = new List<ProjectWrapper>();
         for (PBS_gBUILD_Project__c p : (List<PBS_gBUILD_Project__c>)conProject.getRecords())
            {   ProjectWrapper pw = new ProjectWrapper(p); projects.add(pw);
                if (buildingIdsByPbsProjectId.containsKey(p.ProjectId__c)){pw.BuildingLocationCodes = buildingIdsByPbsProjectId.get(p.ProjectId__c);}
            } 
    }
       
    public class ProjectWrapper
    {
        public PBS_gBUILD_Project__c Pro { get; private set;}
        public List<string> BuildingLocationCodes { get; set; }
        public string buildingCodes { get { return PBS_gBUILD_Utility.format(BuildingLocationCodes, ', '); } set;}
        public string projectName { get; private set; }
       // public string projectManager { get; private set; }
        
        public ProjectWrapper(PBS_gBUILD_Project__c pro)
        {   this.pro = pro;
            this.projectName = PBS_gBUILD_Utility.shorten(pro.ProjectId__r.txtLongName__c, 100);
            this.BuildingLocationCodes = new list<string>();
        }
    }
        
    public PageReference createGbuild() 
    { 
        return new PageReference('/apex/PBS_gBUILD_ProjectCreateGbuild'); 
    }
    public PageReference linkToEpm() 
    { 
        return new PageReference('/apex/PBS_gBUILD_ProjectCreateEpm'); 
    }
    public PageReference proposeEcoe() 
    { 
        return new PageReference('/apex/PBS_gBUILD_ProjectPropose'); 
    }
    public PageReference open() {
        PBS_gBUILD_Utility.syncPBuildings(paramProjectId, paramPbsProjectId);
        return PBS_gBUILD_Utility.createLinkProjectBasics(paramProjectId); 
    }
    
    public String projectName{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('projectName').trim();
            }
            catch(NullPointerException e){ }
            return '';} set;}   
    
    public String projNameLikeSoql{
        get{ 
            try{
                return ' and projectName LIKE '+'\'%';
            }catch(NullPointerException e){} return '';}set;}
    
    public String projectNameSoql(){
        if (!projectName.equals(''))
            return projNameLikeSoql + String.escapeSingleQuotes(projectName)+'%\'';
        else return '';}
    
    public String projectStatus{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('ProjectId__r.txtCurrentState__c').trim();
            }catch(NullPointerException e){ }
            return ''; }set;}
    
    public String projectStatusSoql(){
        if (!projectStatus.equals(''))
            return ' and ProjectId__r.txtCurrentState__c LIKE '+'\'%'+String.escapeSingleQuotes(projectStatus)+'%\'';
        else 
            return '';}
    
    public String projectPhase{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('WorkflowPhaseId__r.Label__c').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
        }    
    public String projectPhaseSoql(){
        if (!projectPhase.equals(''))
            return ' and WorkflowPhaseId__r.Label__c LIKE '+'\'%'+String.escapeSingleQuotes(projectPhase)+'%\'';   
        else 
            return '';
    }
    
    public String projectType{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('ProjectType__c').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
        }
    public String projectTypeSoql(){  
        if (!projectType.equals(''))
            return ' and ProjectType__c LIKE '+'\''+String.escapeSingleQuotes(projectType)+'\'';
        else 
            return '';
    }
    
    public String projectRegion{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('ProjectId__r.txtRegion__c').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
        }
    public String projectRegionSoql(){
        if (!projectRegion.equals(''))
        return ' and ProjectId__r.txtRegion__c = \''+String.escapeSingleQuotes(projectRegion)+'%\'';
        else 
            return '';
    }
    public String projectBuilding{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('buildingCodes').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
    }
    public String projectBuildingSoql(){
        if (!projectBuilding.equals(''))
            return ' and buildingCodes LIKE '+'\'%'+String.escapeSingleQuotes(projectBuilding)+'%\'';
        else 
            return '';
    }
    
    //Select p.ProjectType__c, p.ProjectId__r.txtProjectManager__c, p.ProjectId__r.numProjectNumber__c, p.ProjectId__r.Name, p.ProjectId__c, p.Id From PBS_gBUILD_Project__c p
    
    public String projectManager{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('ProjectId__r.txtProjectManager__c').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
    }
    public String projectManagerSoql(){
        if (!projectManager.equals(''))
            return ' and ProjectId__r.txtProjectManager__c LIKE '+'\'%'+String.escapeSingleQuotes(projectManager)+'%\'';
        else 
            return '';
    }
    
    public String programFullCode{
        get{
            try{
                return Apexpages.currentPage().getParameters().get('ProjectId__r.txtProgramArea_FullCode__c').trim();
            }catch(NullPointerException e){ }
            return '';
        }
            set;
        }
    public String programFullCodeSoql(){
        if (!programFullCode.equals(''))
        return ' and ProjectId__r.txtProgramArea_FullCode__c = \''+String.escapeSingleQuotes(programFullCode)+'%\'';
        else 
            return '';
    }
    
    public PageReference runSearch() {
        soql += projectNameSoql() + projectStatusSoql() + projectPhaseSoql() + projectTypeSoql() + projectRegionSoql() + projectBuildingSoql() + projectManagerSoql() + programFullCodeSoql();
    runQuery();
    return null;
  }  
}