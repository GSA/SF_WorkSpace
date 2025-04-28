public with sharing class PBS_gBUILD_PFundingItemController extends PBS_gBUILD_ProjectIdBaseController 
{
    public PBS_gBUILD_ProjectFunding__c item { get;private set;}
    
    public PBS_gBUILD_PFundingItemController()
    {
        super(
            'Details', 
            false,
            new List<string>{
                'Funding Sources', 'PBS_gBUILD_PFundingSources'                     
            });
        try
        {            
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }            
    }
    
    protected override void bind()
    {
        super.bind();    
        string id = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringPFundingId);
        if (id!=null)
        {
            item = [
                select 
                    id,
                    FundingFY__c,
                    FundingType__c,
                    ProjectId__c,
                    Amount__c,
                    Asid__c,
                    Description__c,
                    FundingSource__c
                from
                    PBS_gBUILD_ProjectFunding__c
                where 
                    id=:id                          
            ];
        }
        if (item==null)
        {
            item = new PBS_gBUILD_ProjectFunding__c();
            item.ProjectId__c = projectId;
            viewMode = false;
        }   
    }
    
    public PageReference edit()
    {
        PBS_gBUILD_Utility.showDebugMessage('EDIT');
        viewMode = false;
        bind();
        return null;
    }
    
    public PageReference save()
    {
        try
        {
            PBS_gBUILD_Utility.showDebugMessage('SAVE');    
            upsert item;
        }
        catch (Exception ex)
        {
            PBS_gBUILD_Utility.showDebugMessage(ex); 
            return null;   
        }                    
        PBS_gBUILD_Utility.RecordProjectModifiedReason(projectId, 'Project funding item was added/updated');                
        viewMode = true;
        bind();
        return null;
    }

    public PageReference saveAndNew()
    {
        PBS_gBUILD_Utility.showDebugMessage('SAVEandNEW');
        upsert item;
        return createPageLink(ProjectPageRefs.PFundingSourcesItem, true);
    }

    public PageReference cancel()
    {
        return createPageLink(ProjectPageRefs.PFundingSources);
    }   
}