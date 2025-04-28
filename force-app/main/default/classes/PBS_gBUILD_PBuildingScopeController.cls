public with sharing class PBS_gBUILD_PBuildingScopeController extends PBS_gBUILD_ProjectIdBaseController
{
    public List<SelectOption> scopeOptionsLevel1rendered { get; private set; }
    public String scopeOptionLevel1Val { get; set; }
    public List<SelectOption> scopeOptionsLevel2rendered { get; private set; }
    public String scopeOptionLevel2Val { get; set; }
    public String scopeOptionLevel3Val { get; set; }
    public PBS_gBUILD_PBuildingScopeSystem__c ss { get; set; }
    private Map<String, Boolean> inScopeByLevel3;
    public Boolean renderL2 { get; private set; }
    public Boolean renderL3 { get; private set; }
    public List<ScopeSystemWrapper> scopeSystems { get; private set; }
    public String selectedScopeSystemId { get; set; }
    public String selectedRecordType { get; set; }
    
    public class Item
    {
        public String label { get; private set; }
        public String value { get; private set; }
        public Boolean canSelect { get; private set; }
        
        public Item(SelectOption so, Boolean canSelect)
        {
            this.label = so.getLabel();
            this.value = so.getValue();
            this.canSelect = canSelect;
        }
    }
            
    public List<Item> scopeOptionsLevel3rendered { get; private set; }
    
    public PBS_gBUILD_PBuildingScopeController()
    {
        super('Scope', true);       
        try
        {
            renderL2 = false;
            renderL3 = false;               
            scopeSystems = new List<ScopeSystemWrapper>();
            ss = new PBS_gBUILD_PBuildingScopeSystem__c();              
            scopeOptionsLevel1rendered = PBS_gBUILD_Utility.convertScopeInfos2Options(1, null);                 
            scopeOptionsLevel2rendered = new List<SelectOption>();  
            scopeOptionsLevel3rendered = new List<Item>();
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }
    
    public class ScopeSystemWrapper implements Comparable
    {
        public PBS_gBUILD_PBuildingScopeSystem__c scopeSystem { get; private set; }
        public String businessNameL1 { get; private set; }
        public String businessNameL2 { get; private set; }
        public String businessNameL3 { get; private set; }
        public String systemCountMsg { get; private set; }
        
        public ScopeSystemWrapper(PBS_gBUILD_PBuildingScopeSystem__c scopeSystem)
        {
            this.systemCountMsg = 'N/A';
            this.scopeSystem = scopeSystem;
            if (scopeSystem==null) return;
            PBS_gBUILD_Utility.ScopeInfo si = PBS_gBUILD_Utility.getScopeInfoByRecordTypeDeveloperName(scopeSystem.RecordType.DeveloperName);
            if (si==null) return;
            if (si.maxSystems>0)
            {
                this.systemCountMsg = scopeSystem.ScopeDetailsCount__c.format();         
            }
            this.businessNameL3 = si.businessName;
            si = PBS_gBUILD_Utility.getScopeInfoById(si.parentId);
            if (si==null) return;
            this.businessNameL2 = si.businessName;
            si = PBS_gBUILD_Utility.getScopeInfoById(si.parentId);
            if (si==null) return;
            this.businessNameL1 = si.businessName;
        }

        public Integer compareTo(Object compareTo) 
        {
            ScopeSystemWrapper that = (ScopeSystemWrapper) compareTo;
            integer ret = this.businessNameL1.compareTo(that.businessNameL1);
            if (ret==0)
            {
                ret = this.businessNameL2.compareTo(that.businessNameL2);
                if (ret==0)
                {
                    ret = this.businessNameL3.compareTo(that.businessNameL3);
                }
            }
            return ret;
        }
    }
    
    protected override void bind()
    {
        super.bind();
        
        List<PBS_gBUILD_PBuildingScopeSystem__c> zs = [
            select 
                id, 
                RecordType.DeveloperName,
                DescopedAt__c,
                DescopingReason__c,
                CreatedDate,
                LastModifiedDate,
                LastModifiedById,
                ScopeDetailsCount__c
            from PBS_gBUILD_PBuildingScopeSystem__c
            where 
                Rahd_ProjectBldgParentId__c = :pbuildingId and
                RecordTypeId <> :PBS_gBUILD_Utility.getScopeRecordTypeId(PBS_gBUILD_Utility.scopeSystemRecordTypeEcm)
                ];
        scopeSystems = new List<ScopeSystemWrapper>();
        inScopeByLevel3 = new Map<String, Boolean>(); 
        for (PBS_gBUILD_PBuildingScopeSystem__c z : zs)
        {
            scopeSystems.add(new ScopeSystemWrapper(z));
            if (z.DescopedAt__c==null)
            {
                showDebugMessage('InScope='+z.RecordType.DeveloperName);
                inScopeByLevel3.put(z.RecordType.DeveloperName, true);
            }
        }
        scopeSystems.sort();
    }   
    
    public PageReference clickLevel1()
    {
        bindAppConfig();
        showDebugMessage('Level1 expand: '+scopeOptionLevel1Val);
        renderL2 = true;
        renderL3 = false;
        scopeOptionsLevel2rendered = PBS_gBUILD_Utility.convertScopeInfos2Options(2, scopeOptionLevel1Val);
        return null;
    }
    
    public PageReference clickLevel2()
    {
        bindAppConfig();
        showDebugMessage('Level2 expand: '+scopeOptionLevel2Val);
        scopeOptionsLevel3rendered.clear();
        List<SelectOption> sos = PBS_gBUILD_Utility.convertScopeInfos2Options(3, scopeOptionLevel2Val);
        for (SelectOption so : sos)
        {
            Item i = new Item(so, !inScopeByLevel3.containsKey(so.getValue()));
            scopeOptionsLevel3rendered.add(i);
        }
        renderL3 = true;
        return null;
    }
    
    public PageReference clickLevel3()
    {
        bindAppConfig();
        showDebugMessage('Level3 click: '+scopeOptionLevel3Val);
        showDebugMessage('ADD: '+scopeOptionLevel3Val);
        renderL3 = false;       
        PBS_gBUILD_Utility.ScopeInfo si = PBS_gBUILD_Utility.getScopeInfo(3, scopeOptionLevel3Val);
        PBS_gBUILD_PBuildingScopeSystem__c s = new PBS_gBUILD_PBuildingScopeSystem__c();
        s.Rahd_ProjectBldgParentId__c = pbuildingId;
        s.RecordTypeId = PBS_gBUILD_Utility.getRecordTypeId('PBS_gBUILD_PBuildingScopeSystem__c', si.RecordType);
        insert s;
        string title = si.CreateSectionTitle();
        PBS_gBUILD_Utility.RecordLastModifiedReason(PBS_gBUILD_Utility.ModifyReasonCreated, si.RecordType, projectId, pbuildingId, s.id,null);
        scopeOptionLevel2Val = '';
        bind();
        return null;
    }
    
    public PageReference open()
    {
        return PBS_gBUILD_Utility.getScopePageRef(selectedScopeSystemId, selectedRecordType); 
    }
}