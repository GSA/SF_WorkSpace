public with sharing class PBS_gBUILD_ProjectCreateGbuildController extends PBS_gBUILD_ProjectCreateBaseController
{
    public PBS_gBUILD_Project__c proj { get; private set; }
    public PBS_Project__c pbsProj { get; private set; }
    
    public PBS_gBUILD_ProjectCreateGbuildController()
    {
        super('Create gBUILD Project');
        proj = new PBS_gBUILD_Project__c();
        pbsProj = new PBS_Project__c();
    }
    
    public PageReference cancel()
    {
        return PBS_gBUILD_Utility.createLinkProjects();
    }
    
    public PageReference create()
    {
        pbsProj.txtCreatedIn__c=PBS_gBUILD_Utility.commonProjCreatorGbuild;
        pbsProj.txtCurrentState__c='Active';         
        insert pbsProj;
        proj.ProjectId__c = pbsProj.Id; 
        proj.WorkflowPhaseId__c = PBS_gBUILD_Utility.findInitialWfStateId(
            (proj.ProjectType__c==PBS_gBUILD_Utility.projectTypeNewConstruction || proj.ProjectType__c==PBS_gBUILD_Utility.projectTypeFullModernization) ?
            PBS_gBUILD_Utility.WfStateMachineTypes.Large : 
            PBS_gBUILD_Utility.WfStateMachineTypes.Small
        );
        proj.ModifiedReason__c = 'Project was created';                        
        insert proj;
        return PBS_gBUILD_Utility.createLinkPBuildingsManage(proj.id);
    }
}