public with sharing class PBS_gBUILD_PBuildingKPMController extends PBS_gBUILD_ProjectIdBaseController 
{
    public string fiscalYearValue { get; set; }
    public EnergyCostPerUnitField[] ecus { get; private set; }
    public PBS_gBUILD_ProjectBuilding__c pb { get; set; }
    public List<PBS_gBUILD_ProjectBuilding__c> proBlist { get; private set; }
    public string actionId { get; set; }                
    public string actionContextName { get; set; }               
    public List<PBS_EuasPerformance__c> euasPerfItems { get; private set; }
    public map<integer, PBS_EuasPerformance__c> euasBaselineByMonth { get; private set; }
    public map<integer, PBS_EuasPerformance__c> euasActualsByMonth { get; private set; }
    public map<integer, PBS_EuasPerformance__c> euasByYear { get; private set; }
    public integer euasBaselinePerformanceYear { get; private set; }
    public List<integer> euasActualYears { get; private set; }
    public integer euasActualYearCount { get {return euasActualYears.size();} }
    public PBS_EuasPerformance__c euasCost { get; private set; }
    public List<SelectOption> euasYears { get; private set; }
    public List<SelectOption> savingsContextSelectOptions { get; private set; } 
    public List<SelectOption> yesNoSelectOptions { get; private set; } 
    public List<UtilitySavingsItem> utilitySavingsItems { get; private set; }        
    public List<PBS_gBUILD_PBuildingScopeSystem__c> Ecms { get; private set; }
    public boolean showBaselineEuasPanel { get { return euasPerfItems.size()>0; } }
    public boolean showUtilitySavingsTypeImpactScope
    {
        get { return utilitySavingsContext == PBS_gBUILD_Utility.utilitySavingsTypeImpactScope; }
    }
    public boolean showUtilitySavingsTypeImpactBuilding
    {
        get { return utilitySavingsContext == PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding; }
    }
    public boolean showUtilitySavingsTypePerformanceBuilding
    {
        get { return utilitySavingsContext == PBS_gBUILD_Utility.utilitySavingsTypePerformanceBuilding; }
    }
    public boolean showUtilityImpactTable { get;  set; }
    public boolean showUtilityPerformanceTable { get;  set; }
    public string utilitySavingsContext{
        get 
        {
            return pb.PerffutUtilitySavContextType__c;
        }
        set
        {
            pb.PerffutUtilitySavContextType__c = value;
        }
    }
    public string perffutIsEuasReferenceYearRep{
        get 
        {
            return pb.PerffutIsEuasReferenceYearRep__c;
        }
        set
        {
            pb.PerffutIsEuasReferenceYearRep__c = value;
        }
    }
    public string engagedInWasteWasteMaterialsMgmt{
        get 
        {
            return pb.WasteWasteMaterialsMgmt__c ? PBS_gBUILD_Utility.yesNoNaTypeYes : PBS_gBUILD_Utility.yesNoNaTypeNo;
        }
        set
        {
            pb.WasteWasteMaterialsMgmt__c = value == PBS_gBUILD_Utility.yesNoNaTypeYes;
        }
    }

    public class EnergyCostPerUnitField extends PBS_gBUILD_Utility.FieldInfo{
        public decimal oVal { get; set; }
        public decimal eVal { get; set; }

        public EnergyCostPerUnitField(Schema.DescribeFieldResult f, decimal o, decimal e)
        {
            super(f);
            oVal = o;
            eVal = e;
        }
    }

    public PBS_gBUILD_PBuildingKPMController(){
        super('KPM', true);
        try{
            viewMode = true;        
            yesNoSelectOptions = PBS_gBUILD_Utility.createYesNoSelectOptions();
            savingsContextSelectOptions = new List<SelectOption>();     
            savingsContextSelectOptions.add(new SelectOption(PBS_gBUILD_Utility.utilitySavingsTypeImpactScope, 'Impact Scope Level'));
            savingsContextSelectOptions.add(new SelectOption(PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding, 'Impact Building Level'));
            savingsContextSelectOptions.add(new SelectOption(PBS_gBUILD_Utility.utilitySavingsTypePerformanceBuilding, 'Performance Building Level'));
            bind();
        }
        catch (Exception ex){
            handleConstructorError(ex);
        }
    }
    
    public PageReference edit(){
        showDebugMessage('EDIT pba:'+pbuildingId);
        viewMode = false;
        bind();
        return null;
    }
    
    public PageReference save(){
        showDebugMessage('SAVE pba:'+pbuildingId);
        
        try
        {
            viewMode = true;
            pb.EuasBaselinePerformanceYear__c = null;
            if (pb.PerffutIsEuasReferenceYearRep__c=='Yes'){
                pb.EuasBaselinePerformanceYear__c = null;
                if (fiscalYearValue!=null && fiscalYearValue!=''){
                    integer y = integer.valueOf(fiscalYearValue);
                    for (PBS_EuasPerformance__c e : euasPerfItems){
                        if (e.FiscalYear__c==y){
                            pb.EuasBaselinePerformanceYear__c = e.id; pb.PerffutChilledWater__c = e.CwaterAmt__c;pb.PerffutElectric__c = e.ElecAmt__c; pb.PerffutGas__c = e.GasAmt__c;pb.PerffutOil__c = e.OilAmt__c;pb.PerffutSteam__c = e.SteamAmt__c;pb.Perffutwater__c = e.WaterAmt__c;pb.Perffutgsf__c = e.Gsf__c; pb.PerffutModelType__c = ''; break;
                        }
                    }
                }
            }
            
            pb.PerffutCostsChilledWater__c = ecus[0].oVal.setScale(6); pb.PerffutCostsElectric__c = ecus[1].oVal.setScale(6); pb.PerffutCostsGas__c = ecus[2].oVal.setScale(6); pb.PerffutCostsOil__c = ecus[3].oVal.setScale(6); pb.PerffutCostsSteam__c = ecus[4].oVal.setScale(6);pb.PerffutCostsWater__c = ecus[5].oVal.setScale(6);
            update pb; update ecms;RecordPageSaved();bind();
        }
        catch (Exception ex){
            showDebugMessage(ex);
        }
        return null;
    }

    public PageReference cancel(){
        showDebugMessage('CANCEL pba:'+pbuildingId);
        viewMode = true;
        bind();
        return null;
    }

    protected override void bind(){    
        super.bind();
        pb = PBS_gBUILD_Utility.loadProjectBuilding(pbuildingId);
        proBlist = new list<PBS_gBUILD_ProjectBuilding__c>();
        proBlist.add(pb);

        ecms = 
        [select 
                EcmId__c,
                EcmCsiCode__c,
                EcmMeasure__c,
                EcmAnticipatedCost__c,
                EcmAnticipatedAnnualSav__c,
                EcmImplemented__c,
                EcmActualCost__c,
                EcmActualEnergySav__c,
                EcmActualWaterSav__c,
                Narr__c
            from PBS_gBUILD_PBuildingScopeSystem__c
            where 
                Rahd_ProjectBldgParentId__c = :pbuildingId and
                RecordTypeId=:PBS_gBUILD_Utility.getScopeRecordTypeId('ARRA_ECM')
        ];
        bindUtilitySavings();

        integer designPlanYear = null;
        try{
            designPlanYear = integer.valueOf([select numDesignPlanYear__c from PBS_Project__c where id=:pbsProjectId].numDesignPlanYear__c);
            designPlanYear = PBS_gBUILD_Utility.convert2DigitTo4DigitYear(designPlanYear);
        }
        catch (Exception ex){}
        showDebugMessage('Design Plan Year='+string.valueOf(designPlanYear));
        
        integer substantiallyCompleteYear = null;
        try{
            substantiallyCompleteYear = pb.Rahd_ProjectParentId__r.SubstantiallyCompleteDate__c.year();
            if (pb.Rahd_ProjectParentId__r.SubstantiallyCompleteDate__c.month()>10){
                substantiallyCompleteYear += 2;
            }
            else{
                substantiallyCompleteYear += 1;
            }
        }
        catch (Exception ex){}
        showDebugMessage('Substantially Complete Year='+string.valueOf(substantiallyCompleteYear));
        fiscalYearValue = null;
        euasBaselinePerformanceYear = 0;
        euasYears = new List<SelectOption>();
        euasCost = new PBS_EuasPerformance__c();
        euasBaselineByMonth = new map<integer, PBS_EuasPerformance__c>();
        euasActualsByMonth = new map<integer, PBS_EuasPerformance__c>();
        euasByYear = new map<integer, PBS_EuasPerformance__c>();
        euasActualYears = new List<integer>();
        euasPerfItems = new List<PBS_EuasPerformance__c>();
        PBS_EuasPerformance__c empty = new PBS_EuasPerformance__c(FiscalMonth__c=-1);
        for (integer z=0;z<13;++z){
            euasBaselineByMonth.put(z, empty);
            euasActualsByMonth.put(z, empty);
        }
        for (PBS_EuasPerformance__c e : 
        [select 
                id,
                CreatedDate,
                recordtype.developername,
                BuildingId__c,
                BuildingFacilityCode__c,
                Building_Category__c,
                Building_Designation__c,
                FiscalMonth__c,
                FiscalYear__c,
                GoalTracked__c,
                Gsf__c,
                MonthCnt__c,
                CwaterAmt__c,
                CwaterCost__c,
                CwaterCostPerUnit__c,
                DmdAmt__c,
                DmdCost__c,
                DmdCostPerUnit__c,
                ElecAmt__c,
                ElecCost__c,
                ElecCostPerUnit__c,
                GasAmt__c,
                GasCost__c,
                GasCostPerUnit__c,
                OilAmt__c,
                OilCost__c,
                OilCostPerUnit__c,
                RenElecAmt__c,
                RenElecCost__c,
                RenElecCostPerUnit__c,
                RenGasAmt__c,
                RenGasCost__c,
                RenGasCostPerUnit__c,
                SteamAmt__c,
                SteamCost__c,
                SteamCostPerUnit__c,
                TotalEnergyBtu__c,
                EnergyUsageIntensity__c,
                WaterAmt__c,
                WaterCost__c,
                WaterCostPerUnit__c,
                CoalAmt__c,
                CoalCost__c,
                name,
                CoalCostPerUnit__c
            from 
                PBS_EuasPerformance__c
            where 
                (BuildingId__c =:pbsbuildingid or BuildingFacilityCode__c=:pb.facilityCode__c or BuildingFacilityCode__c=:pb.BldgId__r.Location_Code_Plus__c)

            order by recordtype.developername asc,FiscalYear__c desc, FiscalMonth__c asc, CreatedDate asc
        ])
        {
        showdebugmessage(e.recordtype.developername+'-'+e.name+'-'+e.CreatedDate);
            if (e.recordtype.developername=='Annual_Performance') {
                integer y = integer.valueOf(e.FiscalYear__c);
                euasByYear.put(y, e);
               
                if (y<=designPlanYear || designPlanYear==null) {
                    euasPerfItems.add(e);                
                    string yearString = string.valueOf(y);
                    euasYears.add(new SelectOption(yearString, yearString));      
                }
                if (y>=substantiallyCompleteYear) {
                    euasActualYears.add(y);
                }
                if (e.id==pb.EuasBaselinePerformanceYear__c) {
                    euasBaselinePerformanceYear = y;
                    euasCost = e;
                    fiscalYearValue = string.valueOf(euasBaselinePerformanceYear);
                }
            }
            else if (e.recordtype.developername=='Monthly_Performance') {
                integer m = integer.valueOf(e.FiscalMonth__c);
                string msg=string.valueof(e.FiscalYear__c)+'-'+string.valueof(m)+'-'+string.valueof(euasBaselinePerformanceYear);
                showDebugMessage(msg);
                if (e.FiscalYear__c==substantiallyCompleteYear) {
                    euasActualsByMonth.put(m, e);
                }
                if (e.FiscalYear__c==euasBaselinePerformanceYear){
                    euasBaselineByMonth.put(m, e);
                }   
            }
        }
        euasActualYears.sort();

        ecus = new EnergyCostPerUnitField[]{
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsChilledWater__c, pb.PerffutCostsChilledWater__c, euasCost.CwaterCostPerUnit__c),
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsElectric__c, pb.PerffutCostsElectric__c, euasCost.ElecCostPerUnit__c),
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsGas__c, pb.PerffutCostsGas__c, euasCost.GasCostPerUnit__c),
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsOil__c, pb.PerffutCostsOil__c, euasCost.OilCostPerUnit__c),
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsSteam__c, pb.PerffutCostsSteam__c, euasCost.SteamCostPerUnit__c),
            new EnergyCostPerUnitField(Schema.sObjectType.PBS_gBUILD_ProjectBuilding__c.fields.PerffutCostsWater__c, pb.PerffutCostsWater__c, euasCost.WaterCostPerUnit__c)
        };
        if (euasCost.id==null) euasCost = null;
    }    
                
    public string radioButtonStr{get;set;}
        
    public void savingsContextRadioChanged(){       
        pb.ModifiedReason__c = 'Savings type changed to '+pb.PerffutUtilitySavContextType__c;    
        update pb;
        RecordPageSaved(pb.ModifiedReason__c);
        bind();    
    }    
    
    public PageReference openEuasItem(){
        return new PageReference('/'+actionId);
    }
    
    public PageReference openChatterItem(){
        return new PageReference('/'+actionId);
    }
    
    public PageReference openUtilitySavingsItem(){
        PageReference pr = new PageReference('/apex/PBS_gBUILD_UtilitySavings');
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringUtilitySavingsId, actionId);
        pr.getParameters().put(PBS_gBUILD_Utility.queryStringUtilitySavingsContext, actionContextName);
//      pr.setRedirect(true);
        return pr;
    }
    
    private void bindUtilitySavings(){
        showUtilityImpactTable = 
            pb.PerffutUtilitySavContextType__c==PBS_gBUILD_Utility.utilitySavingsTypeImpactScope ||
            pb.PerffutUtilitySavContextType__c==PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding;
        showUtilityPerformanceTable = 
            pb.PerffutUtilitySavContextType__c==PBS_gBUILD_Utility.utilitySavingsTypePerformanceBuilding;
        string msg = '';
        msg += 'SavingsContextChanged: '+utilitySavingsContext;
        msg += ' showUtilityImpactTable: '+(showUtilityImpactTable?'true':'false');
        msg += ' showUtilityPerformanceTable: '+(showUtilityPerformanceTable?'true':'false');
        showDebugMessage(msg);
        List<string> usids = new List<string>();
        Map<string, string> contextByUsid = new Map<string, string>();
        if (pb.PerffutUtilitySavContextType__c==PBS_gBUILD_Utility.utilitySavingsTypeImpactScope) {
            List<PBS_gBUILD_PBuildingScopeSystem__c> scopeSystems = 
            [select 
                    id,
                    RecordType.DeveloperName,
                    UtilitySav__c,
                    ActualUtilitySav__c
                from
                    PBS_gBUILD_PBuildingScopeSystem__c
                where
                    Rahd_ProjectBldgParentId__c = :pbuildingId
            ];
            for (PBS_gBUILD_PBuildingScopeSystem__c ss : scopeSystems) {
                if (ss.UtilitySav__c==null) continue;
                PBS_gBUILD_Utility.ScopeInfo si = PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName(ss.RecordType.DeveloperName);
                string context = si==null ? '???' : si.createSectionTitle();
                if (ss.UtilitySav__c!=null){
                    contextByUsid.put(ss.UtilitySav__c, context);
                    usids.add(ss.UtilitySav__c);                
                }
                if (ss.ActualUtilitySav__c!=null) {
                    contextByUsid.put(ss.ActualUtilitySav__c, context);
                    usids.add(ss.ActualUtilitySav__c);                
                }
            }
        }
        else if (pb.PerffutUtilitySavContextType__c==PBS_gBUILD_Utility.utilitySavingsTypeImpactBuilding) {
            if (pb.PerffutUtilitySav__c!=null) {
                contextByUsid.put(pb.PerffutUtilitySav__c, 'Building');
                usids.add(pb.PerffutUtilitySav__c);
            }
            if (pb.ActualUtilitySav__c!=null){
                contextByUsid.put(pb.ActualUtilitySav__c, 'Building');
                usids.add(pb.ActualUtilitySav__c);            
            }
        }            
        List<PBS_gBUILD_UtilitySavings__c> utilitySavings =
        [ select
                id,
                CreatedDate,
                LastModifiedDate,
                LastModifiedById,
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
                Phase__c
            from
                PBS_gBUILD_UtilitySavings__c
            where
                id in :usids
        ];
        showDebugMessage(string.Format('Loaded {0}/{1} utilitySavings items', new string[]{utilitySavings.size().format(), usids.size().format()}));
        map<string, UtilitySavingsItem> savingItemByContext = new map<string,UtilitySavingsItem>();
        for (PBS_gBUILD_UtilitySavings__c z : utilitySavings) {
            string context = contextByUsid.get(z.id);
            if (!savingItemByContext.containsKey(context))  {
                savingItemByContext.put(context, new UtilitySavingsItem(context));
            }
            UtilitySavingsItem item = savingItemByContext.get(context);
            if (z.Phase__c==PBS_gBUILD_Utility.utilitySavingsPhaseActual){
                item.actual = z;
            }
            else {
                item.anticipated = z;
            }
        }
        utilitySavingsItems = new List<UtilitySavingsItem>();
        utilitySavingsItems.addAll(savingItemByContext.values());
        utilitySavingsItems.sort();
    }
    
    public class UtilitySavingsItem implements Comparable {
        public String contextName { get; private set; }
        public PBS_gBUILD_UtilitySavings__c anticipated { get; set; }
        public PBS_gBUILD_UtilitySavings__c actual { get; set; }
        
        public UtilitySavingsItem(string contextName){
            this.contextName = contextName;
        }
       
        public integer compareTo(object other){
            UtilitySavingsItem that = (UtilitySavingsItem) other;
            return contextName.compareto(that.contextName);
        }
    }          
}