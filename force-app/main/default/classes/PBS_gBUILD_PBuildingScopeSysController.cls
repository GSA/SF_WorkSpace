public with sharing class PBS_gBUILD_PBuildingScopeSysController  extends PBS_gBUILD_ProjectIdBaseController
{
    public PBS_gBUILD_Utility.ScopeInfo scopeInfo { get; private set; } 
    public PBS_gBUILD_PBuildingScopeSystem__c scopeSystem { get; private set; }
    public Boolean renderSystemInformation { get; private set; }
    public String recordTypeId { get; private set; }
    public String sectionTitle { get; private set; }
    public List<SystemInfoWrapper> systemInfos { get; private set; }
    public String paramSystemInfoId { get; set; }
         
    public PBS_gBUILD_PBuildingScopeSysController()
    {
        super(
            'Details', 
            true,
            new List<string>{'Scope', 'PBS_gBUILD_PBuildingScope'});
        try
        {
            recordTypeId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringRecordTypeId);
            scopeSystemId = ApexPages.currentPage().getParameters().get(PBS_gBUILD_Utility.queryStringScopeSystemId);
            PBS_gBUILD_Utility.showDebugMessage('OPEN: '+scopeSystemId);        
            bind();
            scopeInfo = PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName(scopeSystem.RecordType.DeveloperName);            
            sectionTitle = scopeInfo.createSectionTitle();
            
            renderSystemInformation = scopeInfo!=null && scopeInfo.maxSystems > 0;
            
            string msg;
            if (scopeSystem.DescopedAt__c!=null){
                msg = 'This scope item was already descoped at '+ scopeSystem.DescopedAt__c.format()+ ' because ['+ scopeSystem.DescopingReason__c + '], editing is no longer allowed'; 
                PBS_gBUILD_Utility.showInfoMessage(msg); readonlyMode = true;
            }
            
            msg = '';
            msg += 'scopeSystemId: '+scopeSystemId;
            if(scopeInfo!=null)
            {
                msg += ' si.max: '+scopeInfo.maxSystems.format();
                msg += ' si.val: '+scopeInfo.value;
            }
            PBS_gBUILD_Utility.showDebugMessage(msg);
        }
        catch (Exception ex){
            handleConstructorError(ex);
        }
    }   

    public PageReference descope(){
        scopeSystem.DescopedAt__c =  date.today();
        update scopeSystem;
        recordLastModifiedReason('Descoped', null, scopeSystem.RecordType.DeveloperName);
        return createPageLink(ProjectPageRefs.PbScope);
    }
    
    public PageReference edit(){
        PBS_gBUILD_Utility.showDebugMessage('EDIT pba:'+pbuildingId);
        viewMode = false;
        return null;
    }
    
    public PageReference save(){
        PBS_gBUILD_Utility.showDebugMessage('SAVE pba:'+pbuildingId);
        update scopeSystem;
        RecordPageSaved();
        viewMode = true;
        bind();        
        return null;
    }

    public PageReference cancel()
    {
        PBS_gBUILD_Utility.showDebugMessage('CANCEL pba:'+pbuildingId);
        viewMode = true;
        bind();
        return null;
    }
    
    public PageReference newSystem()
    {
        return PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(scopeSystemId, '', recordTypeId, true);
    }
    
    public PageReference openSystem()
    {
        return PBS_gBUILD_Utility.getScopeSystemDetailsPageRef(scopeSystemId, paramSystemInfoId, recordTypeId, false);
    }
    
    public PageReference deleteSystem()
    {
        PBS_gBUILD_Utility.showDebugMessage('Delete System Info: '+paramSystemInfoId);
        PBS_gBUILD_PBuildingScopeSystemDetail__c i = [select id, label__c from PBS_gBUILD_PBuildingScopeSystemDetail__c where id=:paramSystemInfoId];
        PBS_gBUILD_Utility.RecordLastModifiedReason(PBS_gBUILD_Utility.ModifyReasonDeleted, i.Label__c, projectId, pbuildingId, scopeSystem.id,i.id);
        delete i;
        bindChildren();
        update scopeSystem;
        bind();
        return null;        
    }
    
    private void bindChildren()
    {
        List<PBS_gBUILD_PBuildingScopeSystemDetail__c> zs = 
        [
            select 
                ScopeSystemDetailRecordType__c,         
                id,
                name,
                CreatedDate,
                LastModifiedDate,
                LastModifiedById,
                Label__c                                
            from PBS_gBUILD_PBuildingScopeSystemDetail__c
            where Rahd_ScopeSysParentId__c=:scopeSystemId
            order by LabelNum__c
        ];
        systemInfos = new List<SystemInfoWrapper>(); 
        for (PBS_gBUILD_PBuildingScopeSystemDetail__c z : zs)
        {
            systemInfos.add(new SystemInfoWrapper(z));
        }
    }   
    
    public class SystemInfoWrapper
    {
        public PBS_gBUILD_PBuildingScopeSystemDetail__c ssd { get; private set; }
        public Boolean touched {get; private set; }
        
        public SystemInfoWrapper(PBS_gBUILD_PBuildingScopeSystemDetail__c ssd)
        {
            this.ssd = ssd;
            this.touched = ssd.LastModifiedDate > ssd.CreatedDate;          
        }
    }
        
    protected override void bind()
    {
        super.bind();
        scopeSystem =
        [
            select 
                id,
                CreatedDate,
                CreatedById,
                LastModifiedDate,
                LastModifiedById,
                RecordType.DeveloperName,
                AdvMeteringConnectedBas__c,
                AdvMeters__c,
                AdvMetersInPlacePriorStart__c,
                AnnualEnergyProductionEffEst__c,
                AnnualSysProduction__c,
                AnticipatedLightingPowerDensity__c,
                AppliancePlugLoadReductions__c,
                AverageWindSpeedArea__c,
                Bas__c,
                BaselineLightingPowerDensity__c,
                BasInterfaceLighting__c,
                BiLevel__c,
                BiLevelSwitching__c,
                BlowerDoorTest__c,
                BoilerCnt__c,
                BoilerCntrlsUpgType__c,
                BoilerDecentralization__c,
                CarbonDioxideSpaceSensors__c,
                CardReaders__c,
                CaulkSealWindows__c,
                ChangeMoreFavorableRateSchedule__c,
                ChillerCnt__c,
                ChillH20Meters__c,
                ChillH20Tracked__c,
                ChilledBeam__c, //SD 020416
                ClerestoryIndoorGlazing__c,
                CogenerationSysInst__c,
                ComishBldgEnvelope__c,
                ComishElectricalSysAutomation__c,
                ComishExteriorPlumbingSysAutomation__c,
                ComishFireSuppressionAlarmSys__c,
                ComishHvacAutomation__c,
                ComishInteriorPlumbingSysAutomation__c,
                ComishLightingSysAutomation__c,
                CondensateCollection__c,
                CondensateRecovery__c,
                ConnectAdvMeteringBas__c,
                Dali__c,
                DaylightHarvestingSensors__c,
                DedicatedOutdoorAirSys__c,
                DelampVendingMachines__c,
                DemandCntrlVentlForAhu__c,
                DemandResponseProgram__c,
                DescopedAt__c,
                DescopingReason__c,
                DigitalBallastsAndOrDigitalCntrls__c,
                DominantType__c,
                ElecMeters__c,
                ElecTracked__c,
                Elevators__c,
                EmrggenfuelMeters__c,
                EmrggenfuelTracked__c,
                EnergyCostReducThroughRateAdj__c,
                EnergyRecovery__c,
                EnergyReductionProgram__c,
                EnergyServiceBillingMeterAuditingRecs__c,
                EnergystarProducts__c,
                EnhComish__c,
                ExhaustAirHeatExchanger__c,
                ExistToilets02Gpf__c,
                ExistToilets02GpfCnt__c,
                ExistToilets35Gpf__c,
                ExistToilets35GpfCnt__c,
                ExistToilets4PlusGpfCnt__c,
                ExistToilets68Gpf__c,
                ExistToilets68GpfCnt__c,
                ExistToilets9PlusGpf__c,
                ExistToilets9PlusGpfCnt__c,
                ExistUrinals0Pt5Gpf__c,
                ExistUrinals0Pt5GpfCnt__c,
                ExistUrinals23Gpf__c,
                ExistUrinals23GpfCnt__c,
                ExistUrinals4PlusGpf__c,
                ExistUrinals4PlusGpfCnt__c,
                ExistUrinalsPt61Gpf__c,
                ExistUrinalsPt61GpfCnt__c,
                FixedWindows__c,
                ForDomesticHotWater__c,
                ForHeat__c,
                FuelCellsInst__c,
                FuelSource__c,
                FuelType__c,
                GasCooling__c,
                GasDistributionSysInst__c,
                GasoilMeters__c,
                GasoilTracked__c,
                GlazingGlareCntrl__c,
                GrayWaterSysInstld__c,
                HartmanLoop__c,
                HeatWheel__c,
                HistoricRoof__c,
                HotWaterHeaterRepairRplc__c,
                HowManyOccSensorsWillBeInstld__c,
                Hydrozoning__c,
                IncludesTerminalUnitRplcs__c,
                IndustrialProcessImprovement__c,
                InstallEfficientSprinklers__c,
                InstallingAutomatedEms__c,
                InstallRainSensingTech__c,
//                InstallVegetativeRoof__c,
                InstallVfdsOnAirHandlerUnits__c,
                InstType__c,
                InsulationActualRValueInstld__c,
                InsulationInst__c,
                IntegrateChillerBoilerCntrlSys__c,
                IrrigationMeter__c,
                IrrigationSmartCntrller__c,
//                LightingAreaRelit__c,
                LightingCntrlsInterface__c,
                LightingTypeBaseline__c,
                LightShelves__c,
                LoadSheddingProgrammingUtilityRebate__c,
                LocalMonitoringBas__c,
                LowerEnergyCostSuppliers__c,
                LowNoWaterLandscaping__c,
                MicroturbinesInstld__c,
                Mmbtuperwell__c,
                ModifyEqpClosedLoopSys__c,
                MotorRplcs__c,
                Narr__c,
//                NarrAdditionalComments__c,
                NarrTbd__c,
                NarrTbdText__c,
                NewDoubleSkinFacade__c,
                NewOtherLavAerators__c,
                NewOtherLavAeratorsCnt__c,
                NewOtherLavSensors__c,
                NewOtherLavSensorsCnt__c,
                NewOtherLowFlowFaucets__c,
                NewOtherLowFlowFaucetsCnt__c,
                NewOtherLowFlowShowerheads__c,
                NewOtherLowFlowShowerheadsCnt__c,
                NewOtherWatersenseFempDevices__c,
                NewOtherWatersenseFempDevicesCnt__c,
                NewUrinals0Pt125Cnt__c,
                NewUrinals0Pt125Gpf__c,
                NewUrinals0Pt125GpfCnt__c,
                NewUrinals0Pt5Gpf__c,
                NewUrinals0Pt5GpfCnt__c,
                NewUrinalsSensors__c,
                NewUrinalsSensorsCnt__c,
                NewUrinalsSnsorsCnt__c,
                NewUrinalsWaterless__c,
                NewUrinalsWaterlessCnt__c,
                NewVestibuleEntrance__c,
                NewWC1Pt28GpfToilets__c,
                NewWC1Pt28GpfToiletsCnt__c,
                NewWC1Pt6GpfToilets__c,
                NewWC1Pt6GpfToiletsCnt__c,
                NewWCDualFlushValves__c,
                NewWCDualFlushValvesCnt__c,
                NewWCLavAerators__c,
                NewWCLavAeratorsCnt__c,
                NewWCLavSensors__c,
                NewWCLavSensorsCnt__c,
                NewWCPressureAssistToilet__c,
                NewWCPressureAssistToiletCnt__c,
                NewWCToiletSensors__c,
                NewWCToiletSensorsCnt__c,
                NewWCUltraLowToilet__c,
                NewWCUltraLowToiletCnt__c,
                NewWCUltratolowToiletCnt__c,
                NoCntrl__c,
                OccupantCntrllability__c,
                OccupantThermalComfortSys__c,
                OccVacancySensors__c,
                OccVacancySensorsForTaskLighting__c,
                OperableWindows__c,
                OriginallyIntendedForDaylighting__c,
                OtherSpecify__c,
                OutdoorSolarCntrl__c,
                OutsideAirModulationInfo__c,
                PhotocellsDaylightSwitching__c,
                PipingInsulationInst__c,
                PlugTimers__c,
                PowerFactorCorrection__c,
                PowerQualityUpgs__c,
                ProductionManufacturingImprovements__c,
                Protocol__c,
                PvArrayCnt__c,
//                PvSysCost__c,
                RadiantFlooring__c, //SD 020416
                RainwaterCollection__c,
                RebalancingAir__c,
                RebalancingWater__c,
                RecommStudyDonePriorInitiation__c,
                RecyclingOtherWasteStreamReductions__c,
                ReflectanceIndoorSurfaces__c,
    //            ReflRoofCoating__c,
//                ReflRoofSqft__c,
//                ReflRoofType__c,
                ReflSolarWindowTinting__c,
                RegionalBasInterface__c,
                RemoteMonitoring__c,
                RemoteMonitoringCentral__c,
                RemoteMonitoringRegional__c,
                RepaintingMasonry__c,
                RepairRplcExistingCondensateReturnSys__c,
                ReplaceAirCooledIceEqp__c,
                ReplaceChillerPumps__c,
                ReplaceCondensorPumps__c,
                ReplaceFeedSys__c,
                ReplacePumps__c,
                ReplaceRefrigerators__c,
                RplcIceEqpHighEfficiencyUnits__c,
                RplcOnceThroughCoolingSys__c,
                RplcType__c,
                RplcWaterCooledEqpAirCooledEqp__c,
                RunAroundCoils__c,
                SensorCnt__c,
                SensorAreaCntrld__c,                
                SensorDrivenElectricalShades__c,
                SidestreamFiltration__c,
                SingleFacade__c,
                Slope__c,
                SmartBldgsProgram__c,
                SolarFacade__c,
                //SqftCntrldByInstldOccSensors__c,
                //SqftCntrldByNewDaylightHarvestSensors__c,
                SqFtOfApplication__c,
                SysCnt__c,
                SriValue__c,
                StairwellCntrls__c,
                SteamMeters__c,
                SteamTracked__c,
                SteamTrapRepairRplc__c,
                StormWaterCollectionAbsorption__c,
                StormwaterTradingCreditsAvailable__c, //SD021216
                SubmeteringInPlacePriorStart__c,
                SysCost__c,
                SysProtocol__c,
                SysSubmetering__c,
                SysType__c,
                TaskAmbientConditioningSys__c,
                TenantSubmetering__c,
                ThermalEnergyStorage__c,
                ThermalImaging__c,
                ThermalStorageSys__c,
                TimeScheduling__c,
                Tonnageperwell__c,
                Totmmbtu__c,
                TotRoofSqFt__c,
                Tottonnage__c,
                TransformersInst__c,
//                TurbineCnt__c,
                UnderfloorAirDistribNontodataCenter__c,
                UnderfloorAirDistributionDataCenter__c,
                UpgBoilerCntrls__c,
                UpgCntrls__c,
                UpgEconomizers__c,
                UpgHeatExchanger__c,
                UpgReplaceInverters__c,
                UrlPvTrackingWebsite__c,
                Utility__c,
                UtilitySav__c,
                ActualUtilitySav__c,
                UvLighting__c,
                VariantRefrigerantFlowSys__c,
                VegFacadeScreenWall__c,
  //              VegRoofSqft__c,
                VfdsInstldOnExistingChiller__c,
                VideoCameras__c,
                WaterMeters__c,
                WatersideEconomizer__c,
                WaterTankRplc__c,
                WaterTracked__c,
                Weatherization__c,
//                WellCnt__c,
                WellDepth__c,
//                WellDrillingCosts__c,
//                WindowCnt__c,
                WindowGlazingType__c,
//                WindSysCost__c,
                Rahd_ProjectBldgParentId__c,
                ExistToilets4PlusGpf__c,
                CoolingTowerMeter__c,
                FillRplc__c,
                NonChemicalWaterTreatment__c,
                VfdsPremiumMotorRplc__c
            from PBS_gBUILD_PBuildingScopeSystem__c
            where id=:scopeSystemId
        ];
        bindChildren();
    }
    
    
}