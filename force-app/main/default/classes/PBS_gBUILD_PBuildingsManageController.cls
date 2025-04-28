public with sharing class PBS_gBUILD_PBuildingsManageController extends PBS_gBUILD_ProjectIdBaseController
{
    public List<BuildingWrapper> linkedBuildings { get; private set;}
    public List<PBS_Building__c> buildings { get; private set; }
    public String paramPbaId { get; set; }
    public String paramBuildingId { get; set; }
    public string regionCode { get; set; }
    private List<string> regionCodes { get; set; }
    public PBS_Project__c project=null;

    public String sortDir { get; private set; }
    public String sortExpr  { get; private set; }
    public integer pageSize { get; private set; }
    public integer pageNum { get; private set; }
    public string resortVal { get; set; }
    public boolean allowPrev
    {
        get { return pageNum > 0; }
    }
    public boolean allowNext { get; private set; }
    public string filterExpr { get; set; }
	//SGanti added 3/2022 SFWS_1700
    public string regionCodeEsc{get; set;}
    
    public PBS_gBUILD_PBuildingsManageController()
    {
        super('Manage Buildings');
        try
        {
            sortDir = 'ASC';
            sortExpr = 'Building_Name__c';
            pageSize = 25;
            pageNum = 0;
            filterExpr = '';
            
            if (!this.pbsProjectCreatedInGbuild)
            {
                String msg = 'This project was not created in gBUILD.  As such, you must use the source system ('+pbsProjectCreatedIn+') to manage its buildings.';
                PBS_gBUILD_Utility.ShowInfoMessage(msg);
            }
    
            project = [select id, txtRegion__c from PBS_Project__c where id=:pbsProjectId];
            regionCode = String.escapeSingleQuotes(project.txtRegion__c.right(2));
            //SGanti added 3/2022 SFWS_1700
            regionCodeEsc = String.escapeSingleQuotes(regionCode);
            regionCodes = new List<string>();
            //SGanti commented out 3/2022
            //regionCodes.add(regionCode);
            //SGanti added 3/2022 SFWS_1700
			regionCodes.add(regionCodeEsc);

            regionCodes.add(regionCode.removeStart('0'));
            string rc = '';
            for (string s : regionCodes)
            {
                rc = rc + s + ', ';
            }
            PBS_gBUILD_Utility.showDebugMessage('my regions: '+rc);
    
            bind();
        }
        catch (Exception ex)
        {
            handleConstructorError(ex);
        }
    }

    public PageReference nextPage()
    {
        return paginate(1);
    }

    public PageReference prevPage()
    {
        return paginate(-1);
    }

    private PageReference paginate(integer delta)
    {
        pageNum += delta;
        if (pageNum < 0) pageNum = 0;
        bind();
        return null;
    }

    public PageReference resort()
    {
        if (resortVal==sortExpr)
        {
            sortDir = sortDir=='ASC'?'DESC':'ASC';
        }
        else
        {
            sortExpr = resortVal;
            sortDir = 'ASC';
        }
        pageNum = 0;
        bind();
        return null;
    }

    public PageReference filter()
    {
        pageNum = 0;
        bind();
        return null;
    }
    
    protected override void bind()
    {   
        super.bind();
        List<PBS_BuildingProjectAssociation__c> pbas = [
            select 
                id,
                rluBuilding__c 
            from PBS_BuildingProjectAssociation__c
            where rluProject__c=:pbsProjectId
            ];
        map<string,string> pbaIdByBuildingId = new map<string,string>();
        for (PBS_BuildingProjectAssociation__c pba : pbas)
        {
            pbaIdByBuildingId.put(pba.rluBuilding__c, pba.id);
        }
        List<PBS_Building__c> bs = [
            select 
                id, 
                Location_Code_Plus__c,
                Facility_Id__c,
                Building_ID__c, 
                Building_Name__c,
                Street_Address__c,
                City__c,
                State_Code__c,
                Region_Code__c
            from PBS_Building__c 
            where 
                id in :pbaIdByBuildingId.keySet()
        ];
        linkedBuildings = new List<BuildingWrapper>();
        for (PBS_Building__c b : bs)
        {
            String pbaId = null;
            if (pbaIdByBuildingId.containsKey(b.id))
            {
                pbaId = pbaIdByBuildingId.get(b.id);
            }
            if (pbsProjectCreatedInGbuild || pbaId!=null)
            {
                BuildingWrapper bw = new BuildingWrapper(b, pbaId, pbsProjectCreatedInGbuild);
                linkedBuildings.add(bw);
            }
        }

        list<string> myBuildingIds = new list<string>();
        myBuildingIds.add(null); //placeholder so there is always at least 1
        myBuildingIds.addAll(pbaIdByBuildingId.keySet());
        filterExpr = filterExpr.trim();
        string whereClause = '';
        if (filterExpr!='')
        {
            whereClause = string.Format(
                'AND (Location_Code_Plus__c like {0} or Building_Name__c like {0} or Street_Address__c like {0} or City__c like {0} or State_Code__c like {0})', 
                new string[]{'\'%'+string.escapeSingleQuotes(filterExpr)+'%\''});
        }
        string soql = string.Format(
'            select '+
'                id,  '+
'                Location_Code_Plus__c, '+
'                Facility_Id__c, '+
'                Building_ID__c,  '+
'                Building_Name__c, '+
'                Street_Address__c, '+
'                City__c, '+
'                State_Code__c, '+
'                Region_Code__c '+
'            from PBS_Building__c  '+
'            where  '+
'                Region_Code__c in ({3}) and '+
'                id not in ({4}) {6}'+
'            order by {0} {1}, id'+
'            LIMIT {2}'+
'            OFFSET {5}',
            new string[]{
                sortExpr, 
                sortDir, 
                string.valueOf(pageSize+1),
                PBS_gBUILD_Utility.format(regionCodes, ',', '{0}', true),
                PBS_gBUILD_Utility.format(myBuildingIds, ',', '{0}', true),
                string.valueOf(pageSize*pageNum),
                whereClause
                });
        PBS_gBUILD_Utility.showDebugMessage(soql);
        buildings = Database.query(soql);
        allowNext = false;
        if (buildings.size()>pageSize)
        {
            allowNext = true;
            buildings.remove(pageSize);
        }
        PBS_gBUILD_Utility.showDebugMessage(string.Format(
            'PageNum={0} PageSize={1} allowPrev={2} allowNext={3} SortDir={4} SortExpr={5} FilterExpr=[{6}]',
            new string[]{string.valueOf(pageNum), string.valueOf(pageSize), allowPrev?'t':'f',  allowNext?'t':'f', sortDir, sortExpr, filterExpr}));
    }
    
    public class BuildingWrapper
    {
        public PBS_Building__c building { get; private set; }
        public String pbaId { get; private set; }
        public Boolean renderLinkButton { get; private set; }
        public Boolean renderUnlinkButton { get; private set; }
        
        public BuildingWrapper(PBS_Building__c building, String pbaId, Boolean canAlter)
        {
            this.building = building;
            this.pbaId = pbaId;
            this.renderLinkButton = canAlter && pbaId==null;
            this.renderUnlinkButton = canAlter && !this.renderLinkButton;
        }   
    }
    
    public PageReference link() 
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'LINK: projId='+projectId+' pbsProjId='+pbsProjectId+' buildingId='+paramBuildingId));
        PBS_BuildingProjectAssociation__c pba = new PBS_BuildingProjectAssociation__c(
            rluProject__c=pbsProjectId, 
            rluBuilding__c =paramBuildingId
            );
        insert pba;        
        PBS_gBUILD_Utility.RecordProjectModifiedReason(projectId, 'A building was linked');                
        super.syncPBuildings();
        return createPageLink(ProjectPageRefs.PManageBuildings, true);
    }       
    
    public PageReference unlink() 
    {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'UNLINK: projId='+projectId+' pbsProjId='+pbsProjectId+' buildingId='+paramBuildingId));
        PBS_BuildingProjectAssociation__c pba = [select id from PBS_BuildingProjectAssociation__c where 
            id = :paramPbaId];
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'DELETE pba:'+pba.id));
        delete pba;
        return createPageLink(ProjectPageRefs.PManageBuildings, true);
    }       
    
    public PageReference openLinkedBuilding() 
    {
        return createPageLink(ProjectPageRefs.PbBasics, PBS_gBUILD_Utility.queryStringBuildingId, paramBuildingId);
    }       

    public PageReference openUnlinkedBuilding() 
    {
        return new PageReference('/'+paramBuildingId);
    }       
}