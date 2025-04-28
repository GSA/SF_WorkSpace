public with sharing class PBS_gBUILD_PBuildingCloseoutController extends PBS_gBUILD_ProjectIdBaseController
{
    public PBS_gBUILD_ProjectBuilding__c clo { get; private set; }
    public string epmCatalog { get; private set; }
    
    public PBS_gBUILD_PBuildingCloseoutController()
    {
        super('Closeout', true);
        try
        {
            epmCatalog = PBS_gBUILD_Utility.epmCatalogCloseout;
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
        clo = PBS_gBUILD_Utility.loadProjectBuilding(pbuildingid);
    }

    public PageReference edit() 
    {
        viewMode = false;
        bind();
        return null;
    }  
         
    public PageReference cancel() 
    {
        return createPageLink(ProjectPageRefs.PbCloseout, true);
    }  
    
    public PageReference save() 
    {
        clo.ModifiedReason__c = 'Closeout information was updated';
        update clo;
        return createPageLink(ProjectPageRefs.PbCloseout, true);
    }  
}