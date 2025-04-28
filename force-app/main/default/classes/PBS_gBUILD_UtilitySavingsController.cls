public with sharing class PBS_gBUILD_UtilitySavingsController extends PBS_gBUILD_ProjectIdBaseController 
{
    public PBS_gBUILD_UtilitySavings__c item { get;private set;}
    public string contextName { get;private set;}
    public string itemId { get; set;}
    public PBS_gBUILD_UtilitySavingsController()
    {
        super(
            'Savings', 
            true,
            new List<string>{
                'KPM', 'PBS_gBUILD_PBuildingKPM'                        
            });
        contextName = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringUtilitySavingsContext);
        itemId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringUtilitySavingsId);
        PBS_gBUILD_Utility.showDebugMessage('ContextName: '+contextName);
        PBS_gBUILD_Utility.showDebugMessage('ID: '+itemId);             
        bind();
    }
    
    protected override void bind()
    {
        super.bind();
    list<PBS_gBUILD_UtilitySavings__c>itemList= 
       [
            select 
                id,
                CreatedDate,
                LastModifiedDate,
                LastModifiedById,
                Phase__c,
                TimePeriod__c,
                CalculatedSimplePaybackF__c,
                ChilledWaterSav__c,
                EcmTotCost__c,
                ElectricSav__c,
                FinanceContractorMarkup__c,
                GasSav__c,
                ImplementationPrice__c,
                OilSav__c,
                OtherEnergySav__c,
                OtherRelatedCostSav__c,
                SourceOtherEnergySav__c,
                SourceOtherRelatedSav__c,
                SteamSav__c,
                TotAnnualCostSavF__c,
                TotAnnualEnergyCostSavCalculatedF__c,
                TotEnergySavCalculated__c,
                TotEnergySavUserReported__c,
                WaterSav__c,
                EnergyBaseline__c,
                AnnualEnergyBaseline__c,
                AnnualWaterBaseline__c
            from PBS_gBUILD_UtilitySavings__c 
            where id = :itemId limit 1
            ];
            
            if(itemList.size()>0)
            {
            
             item = itemList.get(0);
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
        PBS_gBUILD_Utility.showDebugMessage('SAVE');
        viewMode = true;
        if(item!=null)
        upsert item;
        bind();
        return null;
    }

    public PageReference cancel()
    {
        PBS_gBUILD_Utility.showDebugMessage('CANCEL');
        viewMode = true;
        bind();
        return null;
    }   
}