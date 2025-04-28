public with sharing class PBS_gBUILD_CookieHelper {

    private List<Cookie> cookies { get; set; }
    public String pbsProjectId { get; private set; }
    public String pbsProjectCreatedIn { get; private set; }
    public String numProjectRegion { get; private set; }
    public string wfPhaseId  { get; private set; }
    public string wfPhaseName  { get; private set; }
    public String prolianceAccountName { get; private set; }
    public String pmName { get; private set; }
    public Boolean isProjectFormative { get; private set; }
    public string projectOwnerId { get; private set; }
    
    public PBS_gBUILD_CookieHelper()
    {
        cookies = new List<Cookie>();
    }
        
    public void setPageName(String pageName)
    {
        cookies.add(new Cookie('PBS_gBUILD_PageName', pageName, null, -1, false));
//      ApexPages.currentPage().setCookies(cookies);            
    }
    
    public void setExtraBreadcrumbs(List<string> extraBreadcrumbs)
    {
        string s = '';
        if (extraBreadcrumbs!=null)
        {
            for (string z : extraBreadcrumbs)
            {
                if (s.length()>0)
                {
                    s+=',';
                }
                s+=z;
            }
        }       
        cookies.add(new Cookie('PBS_gBUILD_ExtraBreadcrumbs', s, null, -1, false));
    }
    
    public void setCookies()
    {
        ApexPages.currentPage().setCookies(cookies);                
    }
    
    public void resetProjectCookies()
    {
        setProjectCookies(null);
    }
    
    public String getProjectId()
    {
        return ApexPages.currentPage().getCookies().get('PBS_gBUILD_ProjectId').getValue();
    }
    
    public String getBuildingId()
    {
        return ApexPages.currentPage().getCookies().get('PBS_gBUILD_BuildingId').getValue();
    }   
    
    public void setProjectCookies(String projectId)
    {
        setProjectCookies(projectId, null);
    }
    
    public void setDebugVal(String val)
    {
        cookies.add(new Cookie('PBS_gBUILD_DBG', val, null, -1, false));    
    }
    
    public void setProjectCookies(String projectId, String pbuildingId)
    {       
        if (projectId==null || projectId=='')
        {
            cookies.add(new Cookie('PBS_gBUILD_ProjectId', '', null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_ProjectName', '', null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_ProjectNameField', '', null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingId', '', null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingIds', '', null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingNames', '', null, -1, false));               
        }
        else        
        {
            String projectIdEscapeSingleQuotes = String.isNotBlank(projectId)?string.escapeSingleQuotes(projectId):projectId;
            String strQuery = 'select ';
            strQuery += 'id,Name,OwnerId,ProjectId__c,ProjectId__r.txtLongName__c,';
            strQuery += 'ProjectId__r.txtRegion__c,ProjectId__r.txtCreatedIn__c,';
            strQuery += 'ProjectId__r.txtProlianceAccountName__c,ProjectId__r.txtCurrentState__c,';
            strQuery += 'ProjectId__r.txtProjectManager__c,WorkflowPhaseId__c,';
            strQuery += 'WorkflowPhaseId__r.Label__c,WorkflowPhaseId__r.Parent__r.Name';
            strQuery += ' from PBS_gBUILD_Project__c';
            strQuery += ' where id =: projectIdEscapeSingleQuotes';
            PBS_gBUILD_Project__c gbProj = Database.query(strQuery);
            
            /*
            PBS_gBUILD_Project__c gbProj = [
                select id, 
                    Name,
                    OwnerId,
                    ProjectId__c,
                    ProjectId__r.txtLongName__c, 
                    ProjectId__r.txtRegion__c, 
                    ProjectId__r.txtCreatedIn__c,
                    ProjectId__r.txtProlianceAccountName__c,
                    ProjectId__r.txtCurrentState__c,
                    ProjectId__r.txtProjectManager__c,
                    WorkflowPhaseId__c,
                    WorkflowPhaseId__r.Label__c,                    
                    WorkflowPhaseId__r.Parent__r.Name
                from PBS_gBUILD_Project__c
                where id=:projectId
            ];
            */
            
            pbsProjectId = gbProj.ProjectId__c;         
            pbsProjectCreatedIn = gbProj.ProjectId__r.txtCreatedIn__c;
            numProjectRegion = gbProj.ProjectId__r.txtRegion__c;
            wfPhaseId = gbProj.WorkflowPhaseId__c;
            wfPhaseName = gbProj.WorkflowPhaseId__r.Label__c;
            prolianceAccountName = gbProj.ProjectId__r.txtProlianceAccountName__c;
            pmName = gbProj.ProjectId__r.txtProjectManager__c;
            isProjectFormative = gbProj.ProjectId__r.txtCurrentState__c==PBS_gBUILD_Utility.projectStateFormative;
            projectOwnerId = gbProj.OwnerId;
            
            Set<string> uniqueBuildings = new Set<string>();
            String bids=null;   
            String bnames=null;
            List<PBS_BuildingProjectAssociation__c> pbas = [
                select 
                    id,
                    rluBuilding__r.Location_Code_Plus__c, 
                    rluBuilding__r.Building_Name__c 
                from PBS_BuildingProjectAssociation__c
                where rluProject__c=:pbsProjectId
            ];                  
            for (PBS_BuildingProjectAssociation__c pba : pbas)
            {
                if (uniqueBuildings.contains(pba.rluBuilding__r.Location_Code_Plus__c)) continue;
                uniqueBuildings.add(pba.rluBuilding__r.Location_Code_Plus__c);
                if (bids==null)
                {
                    bids = '';
                    bnames = '';
                }
                else
                {
                    bids += '`';
                    bnames += '`';              
                }
                bids += pba.rluBuilding__r.Location_Code_Plus__c;
                bnames += pba.rluBuilding__r.Building_Name__c;
            }
            cookies.add(new Cookie('PBS_gBUILD_ProjectId', projectId, null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_ProjectName', gbProj.ProjectId__r.txtLongName__c, null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_ProjectNameField', gbProj.Name, null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingId', pbuildingId, null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingIds', bids, null, -1, false));
            cookies.add(new Cookie('PBS_gBUILD_BuildingNames', bnames, null, -1, false));                   
            cookies.add(new Cookie('PBS_gBUILD_WfMachine', gbProj.WorkflowPhaseId__r.Parent__r.Name, null, -1, false));       
        }
    }
}