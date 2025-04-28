public with sharing class PBS_gBUILD_ProjectBasicsController extends PBS_gBUILD_ProjectIdBaseController
{
    public PBS_gBUILD_Utility.LinkedObjectFieldInfo projectNameLink { get; private set; }
    
    public Boolean viewModeCommon
    {
        get
        {
            return viewMode || pro==null || pbsPro.txtCreatedIn__c!=PBS_gBUILD_Utility.commonProjCreatorGbuild;
        }
    }
    public Boolean editModeCommon
    {
        get
        {
            return !viewModeCommon;
        }
    }
    public PBS_gBUILD_Project__c pro { get; private set; }
    public PBS_Project__c pbsPro { get; private set; }
    
    public PBS_gBUILD_ProjectBasicsController()
    {
        super('Project Basics');
        try{
            bind();
        }
        catch (Exception ex){ handleConstructorError(ex);}        
    }
    
    public PageReference edit() 
    {
        viewMode = false;
        bind();
        return null;
    }  
         
    public PageReference cancel() 
    {
        viewMode = true;
        bind();
        return null;
    }  
    
    public PageReference save() 
    {
        update pro;
        update pbsPro;
        viewMode = true;
        RecordPageSaved();
        bind();
        return null;
    }      
    
    protected override void bind()
    {
        super.bind();
        
        pro = 
        [
            select
                name,
                id, 
                ProjectID__c, 
                UNID__c, 
                BudgetActivityCode__c,
                WorkflowPhaseId__r.Label__c,
                ProjectType__c,
                Escalation__c,
                ContractType__c,
                ContractTypeOther__c,                
                SubstantiallyCompleteDate__c,
                LastModifiedById,
                LastModifiedDate,
                AwardDate__c
            from PBS_gBUILD_Project__c
            where id=:ProjectId
        ];
        
        pbsPro = [
            select
                id, 
                txtCreatedIn__c,
                txtCurrentState__c,
                txtProjectManager__c,
                txtProgram__c,
                txtProgramArea_FullCode__c, 
                txtLongName__c,
                txtProjectDescription__c,
                txtRegion__c,
                txtProlianceAccountName__c,
                numConstructionPlanYear__c,
                numDesignPlanYear__c,
                numProjectNumber__c                
            from PBS_Project__c
            where id=:pro.ProjectID__c
            ];
            
        projectNameLink = new PBS_gBUILD_Utility.LinkedObjectFieldInfo(Schema.sObjectType.PBS_Project__c.fields.txtLongName__c, pbsProjectId, pbsPro.txtLongName__c);            
        
        confirmKeyProjectItems();
    }
    
    private void confirmKeyProjectItems()
    {            
        set<string> buildingIds = new set<string>();
        for (PBS_BuildingProjectAssociation__c bpa : 
        [
            select rluBuilding__c
            from PBS_BuildingProjectAssociation__c
            where 
                rluProject__c =:pbsProjectId and
                rluBuilding__c<>null
        ])
        {
            buildingIds.add(bpa.rluBuilding__c);
        }
        boolean missingPba = false;                
        for (PBS_gBUILD_ProjectBuilding__c pb :
        [
            select id, BldgId__c
            from PBS_gBUILD_ProjectBuilding__c
            where Rahd_ProjectParentId__c =:ProjectId
        ])
        {
            if (buildingIds.contains(pb.BldgId__c)) continue;
            PBS_gBUILD_Utility.ShowErrorMessage(string.format('A project building ({0}) exists without an underlying buildingProjectAssociation record.  Please contact {1}.', new string[]{pb.id, AppConfig.HelpDeskEmail__c}));
        }
                
        if (!missingPba && buildingIds.size()==0){
            PBS_gBUILD_Utility.ShowWarningMessage('No buildings have been assigned to this project');
        }
    }
}