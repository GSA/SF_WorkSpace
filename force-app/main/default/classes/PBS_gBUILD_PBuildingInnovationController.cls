public with sharing class PBS_gBUILD_PBuildingInnovationController extends PBS_gBUILD_ProjectIdBaseController
{
    public List<PBS_gBUILD_PBuildingInnovation__c> items { get; private set; }
    public String actionId { get; set; }

    public PBS_gBUILD_PBuildingInnovationController ()
    {
        super('Innovation', true);
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
        items = 
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
                where Rahd_ProjectBldgParentId__c=:pbuildingid 
            ];
        for(PBS_gBUILD_PBuildingInnovation__c z : items)
        {
              z.ProblemStatement__c = PBS_gBUILD_Utility.shorten(z.ProblemStatement__c);
              z.TechDescription__c = PBS_gBUILD_Utility.shorten(z.TechDescription__c);
              z.PotentialImpact__c = PBS_gBUILD_Utility.shorten(z.PotentialImpact__c);
        }
    }

    public PageReference add() 
    {
        return createPageLink(ProjectPageRefs.PbInnovationsItem);
    }       

    public PageReference open() 
    {
        return createPageLink(ProjectPageRefs.PbInnovationsItem, PBS_gBUILD_Utility.queryStringPInnovationId, actionId);
    }       

    public PageReference del() 
    {
        PBS_gBUILD_Utility.showDebugMessage('Delete innovation: '+actionId);
        PBS_gBUILD_PBuildingInnovation__c item = [
            select id 
            from PBS_gBUILD_PBuildingInnovation__c 
            where id=:actionId
        ];
        delete item;
        return createPageLink(ProjectPageRefs.PbInnovations, true);
    }      
}