public with sharing class PBS_gBUILD_PFundingSourcesController extends PBS_gBUILD_ProjectIdBaseController
{
    public string actionId { get; set; }
    public List<PBS_gBUILD_ProjectFunding__c> items { get; private set; }
    
    public PBS_gBUILD_PFundingSourcesController()
    {
        super('Funding Sources');
        try
        {
            if (isProjectFormative)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'This page is not applicable to formative projects.'));        
            }
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
        items = [
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
                ProjectId__c=:projectId                         
        ];
        for (PBS_gBUILD_ProjectFunding__c z : items)
        {
            z.Description__c = PBS_gBUILD_Utility.shorten(z.Description__c);
        }
    }
    
    public PageReference add() 
    {
        return createPageLink(ProjectPageRefs.PFundingSourcesItem);
    }       

    public PageReference open() 
    {
        return createPageLink(ProjectPageRefs.PFundingSourcesItem, PBS_gBUILD_Utility.queryStringPFundingId, actionId);
    }       
    
    public PageReference del() 
    {
        PBS_gBUILD_Utility.showDebugMessage('DELETE');
        PBS_gBUILD_ProjectFunding__c[] zs = [select id from PBS_gBUILD_ProjectFunding__c where id=:actionId];
        delete zs;
        PBS_gBUILD_Utility.RecordProjectModifiedReason(projectId, 'Project funding item was deleted');        
        return createPageLink(ProjectPageRefs.PFundingSources, true);
    }   
}