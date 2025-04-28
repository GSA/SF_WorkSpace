public with sharing class PBS_gBUILD_PBuildingScopeDetController  extends PBS_gBUILD_ProjectIdBaseController
{
    public PBS_gBUILD_Utility.ScopeInfo scopeInfo { get; private set; } 
    public String scopeSystemId { get;  private set; }
    public String scopeSystemDetailsId { get;  private set; }
    public PBS_gBUILD_PBuildingScopeSystemDetail__c ssd { get;  private set; }
    public String recordType { get; private set; }
    public String sectionTitle { get; private set; }
    public String summaryInformationTitle { get; private set; }
        
    public PBS_gBUILD_PBuildingScopeDetController()
    {
        super(
            'System', 
            true,
            new List<string>{
                'Scope', 'PBS_gBUILD_PBuildingScope', 
                'Details', 
                    PBS_gBUILD_Utility.getScopePageRef(
                        ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringScopeSystemId),
                        ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringRecordTypeId)     
                    ).getUrl().removeStartIgnoreCase('/apex/')              
            });
        try
        {
            recordType = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringRecordTypeId);
            scopeSystemId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringScopeSystemId);
            scopeSystemDetailsId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringScopeDetailId);
            viewMode = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringPageMode) != PBS_gBUILD_Utility.pageModeEdit; 
            showDebugMessage(string.Format('OPEN: scopeSystemId={0}, scopeSystemDetailsId={1}, recordType={2}', new string[]{scopeSystemId, scopeSystemDetailsId, recordType}));     
            bind();            
            showDebugMessage('Warranty: '+(scopeInfo.allowWarranty?'true':'false'));     
            showDebugMessage('Max: '+scopeInfo.maxSystems.format());                 
            summaryInformationTitle = 'Summary Information';
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }   
    
    public PageReference edit()
    {
        showDebugMessage('EDIT pba:'+pbuildingId);
        viewMode = false;
        bind();
        return null;
    }
    
    public PageReference save()
    {
        showDebugMessage('SAVE pba:'+pbuildingId);

        if (ssd.id==null)
        {
            PBS_gBUILD_PBuildingScopeSystem__c ss = [select id, ScopeDetailsMaxSeq__c from PBS_gBUILD_PBuildingScopeSystem__c where id=:ssd.Rahd_ScopeSysParentId__c];
            try
            {
                //when there are no children... dereferencing results in an exception
                ssd.LabelNum__c = ss.ScopeDetailsMaxSeq__c+1;
            }
            catch (exception zzz)
            {
                ssd.LabelNum__c = 1;            
            }
            ssd.Label__c = String.format(scopeInfo.labelFormat, new string[]{ssd.LabelNum__c.format()});
            insert ssd;
            PBS_gBUILD_Utility.RecordLastModifiedReason(PBS_gBUILD_Utility.ModifyReasonCreated, ssd.Label__c, projectId, pbuildingId, ssd.Rahd_ScopeSysParentId__c, ssd.id);
        }
        else
        {
            update ssd;
            PBS_gBUILD_Utility.RecordLastModifiedReason(PBS_gBUILD_Utility.ModifyReasonUpdated, ssd.Label__c, projectId, pbuildingId, ssd.Rahd_ScopeSysParentId__c, ssd.id);
        }
        return PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(ssd.Rahd_ScopeSysParentId__c, ssd.id, recordType, false);
    }

    public PageReference saveAndNew()
    {
        save();
        showDebugMessage('NEW pba:'+pbuildingId);
        return PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(ssd.Rahd_ScopeSysParentId__c, '', recordType, true);
    }

    public PageReference cancel()
    {
        showDebugMessage('CANCEL pba:'+pbuildingId);
        if (ssd.id==null)
        {
            return PBS_gBUILD_Utility.getScopePageRef(scopeSystemId, recordType);
        }
        else
        {
            bind();
            viewMode = true;
            return null;
        }
    }
    
    protected override void bind()
    {
        super.bind();
        if (scopeSystemDetailsId==''||scopeSystemDetailsId==null)
        {
            ssd = new PBS_gBUILD_PBuildingScopeSystemDetail__c();
            ssd.Rahd_ScopeSysParentId__c = scopeSystemId;
            ssd.RecordTypeId = PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystemDetail__c', recordType);
            scopeInfo = PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName(recordType);
            showDebugMessage(string.Format('Creating mock detail record of recordType=[{0}] with id={1}', new string[]{recordType, ssd.RecordTypeId}));
        }
        else
        {
            ssd = 
            [
                select
                    id,
                    CreatedDate,
                    CreatedById,
                    LastModifiedDate,
                    LastModifiedById,
                    RecordType.DeveloperName,                
                    Rahd_ScopeSysParentId__r.RecordType.DeveloperName,
                    AbsorptionChiller__c,
                    AffectedSpace__c,
                    AffectedSpaceOutdoor__c,
                    AffectedSpaceOtherText__c,
                    AnnualEnergyProductionEfficiency__c,
                    AnticipatedLightingPowerDensity__c,
                    BoilerExhaustStackRecovery__c,
                    BoilerCapacity__c,
                    CarbonDioxideSpaceSensors__c,
                    CeilingMountedPendantoutUplight__c,
                    CeilingMountedPendantUplight__c,
                    ChillerCapacity__c,                
                    ChillerInstType__c,                
                    ChillerType__c,
                    Cogeneration__c,
                    CompactFluorescent__c,
                    CondensateCollection__c,
                    CondensateRecovery__c,
                    CondensingType__c,
                    ConstantVolume__c,
                    CoolingSysCriteria__c,
                    Coolrooftype__c,
                    DedicatedOutdoorAirSys__c,
                    DemandCntrlVentlForAhu__c,
                    Downlights__c,
                    DuelFuel__c,
                    ElecMeters__c,
                    FiberOpticLightingTechnologies__c,
                    Fluorescent__c,
                    FuelType__c,
                    GeothermalInstType__c,
                    GridLayIn__c,
                    HeatExchangerBoilerLoopBldgLoop__c,
                    HeatRecovery__c,
                    Hid__c,
                    IncludesTerminalUnitRplcs__c,
                    Induction__c,
                    InstType__c,
                    Label__c,
                    LabelNum__c,
                    LEDAverageReportedLifespan__c,
                    LEDAverageReportedLifespanUnit__c,
                    LEDIsLightingSource__c,
                    LEDMfgLocOther__c,
                    LEDMfgName__c,
                    LEDMfgState__c,
                    MagneticBearingCompressor__c,
                    MfgLocOther__c,
                    MfgName__c,
                    MfgState__c,
                    MotorSizeHpNewAirHandlers__c,
                    Narr__c,
                    OtherSpecify__c,
                    PanelRating__c,
                    PendantDirectIndirect__c,
                    Primarysecondary__c,
                    PvInstType__c,
                    PvSysCapacity__c,
                    Rahd_ScopeSysParentId__c,
                    RecessedHighPerfLensed__c,
                    RefrigerantType__c,
                    RefrigerantTypeOtherText__c,
                    RepairedCoolRoofType__c,
                    RepairedRoofType__c,
                    Rooftype__c,
                    Rooftypeothertext__c,
                    ScopeSystemDetailRecordType__c,
                    SodiumVapor__c,
                    SolarModuleType__c,
                    SolarModuleTypeOtherText__c,
                    SolarThermalSysCapacity__c,
                    SpectrallyEnhLighting__c,
                    SqFtOfApplication__c,
                    SummerBoiler__c,
                    SurfaceMounted__c,
                    SysCnt__c,
                    SysCost__c,
                    SysInstType__c,
                    T5T5HoLamps__c,
                    T8Lamps__c,
                    TotCfmNewAirHandlers__c,
                    UnderCabinetAndOrDesktopTaskLighting__c,
                    UniqueFiltration__c,
                    UpgEconomizers__c,
                    UvLighting__c,
                    VarPrimaryPumping__c,
                    VarRefrigerantFlowSys__c,
                    Vfds__c,
                    VsdCnt__c,
                    Wallwashing__c,
                    WatersideEconomizers__c,
                    WindTurbineCapacity__c,
                    WntyARRACompliance__c,
                    WntyARRAComplianceExpln__c,
                    WntyDuration__c,
                    WntyEffectiveDate__c,
                    WntyOneYearFollowUp__c,
                    WntyPOCEmail__c,
                    WntyPOCName__c,
                    WntyPOCPhone__c,
                    WntyProviderName__c,
                    WntyProviderType__c,
                    WntyProviderTypeOther__c,
                    WntyUncertaintyReason__c,
                    WntyUncertaintyReasonExpln__c,
                    WrkstatSpecificPendantDigitalCntrl__c
                from PBS_gBUILD_PBuildingScopeSystemDetail__c
                where id=:scopeSystemDetailsId              
            ];
            scopeInfo = PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName(ssd.Rahd_ScopeSysParentId__r.RecordType.DeveloperName);
            showDebugMessage('Loaded existing detail record '+scopeSystemDetailsId);
        }
        if (ssd.Label__c==null)
        {
            sectionTitle = scopeInfo.createSectionTitle();
        }
        else
        {
            sectionTitle = ssd.Label__c; 
        }
    }
}