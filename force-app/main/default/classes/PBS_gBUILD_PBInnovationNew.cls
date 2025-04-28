public with sharing class PBS_gBUILD_PBInnovationNew extends PBS_gBUILD_ProjectIdBaseController 
{
    public PBS_gBUILD_PBuildingInnovation__c item { get; private set; }
    
    public PBS_gBUILD_PBInnovationNew() 
    {       
        super(
            'Details', 
            true,
            new List<string>{
                'Innovation', 'PBS_gBUILD_PBuildingInnovation'                      
            });
        bind();
    }
    
    protected override void bind()
    {    
        super.bind();
        string id = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringPInnovationId);
        if (id!=null)
        {
            item = 
            [
                select 
                    id,
                    name,
                    Category__c,
                    CategoryOther__c,
                    FundingStatus__c,
                    IsBaselineDataAvailable__c,
                    WasMeasurementVerificationIncluded__c,                  
                    Rahd_ProjectBldgParentId__c,
                    ProblemStatement__c,
                    TechDescription__c, 
                    PotentialImpact__c
                from PBS_gBUILD_PBuildingInnovation__c 
                where id=:id
            ]; 
        }
        if (item==null)
        {
            item = new PBS_gBUILD_PBuildingInnovation__c();
            item.Rahd_ProjectBldgParentId__c = pbuildingId;
            viewMode = false;
        }   
    }

    public PageReference edit()
    {
        PBS_gBUILD_Utility.showDebugMessage('EDIT');
        bind();
        viewMode = false;
        return null;
    }
    
    public PageReference save()
    {
        PBS_gBUILD_Utility.showDebugMessage('SAVE');
        viewMode = true;
        upsert item;
        PBS_gBUILD_Utility.RecordProjectBuildingModifiedReason(pbuildingId, 'Innovation added/updated');
        bind();
        return null;
    }

    public PageReference saveAndNew()
    {
        save();
        return createPageLink(ProjectPageRefs.PbInnovationsItem, true);
    }

    public PageReference cancel()
    {
        return createPageLink(ProjectPageRefs.PbInnovations);
    }   
}