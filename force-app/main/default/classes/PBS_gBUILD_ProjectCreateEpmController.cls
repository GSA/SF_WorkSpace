public with sharing class PBS_gBUILD_ProjectCreateEpmController extends PBS_gBUILD_ProjectCreateBaseController
{
    public List<EpmProjectWrapper> epmProjects { get; private set; }
    public String createFromEpmId { get; set; }
    public PBS_gBUILD_Project__c proj { get; private set; } 
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
    public String selectedPbsProjectId { get; set; }

    public PBS_gBUILD_ProjectCreateEpmController()
    {
        super('Project Create');
        
        sortDir = 'ASC';
        sortExpr = 'txtLongName__c';
        pageSize = 25;
        pageNum = 0;
        filterExpr = '';

        proj = new PBS_gBUILD_Project__c();

        bind();
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
        epmProjects = new List<EpmProjectWrapper>();
        
        List<PBS_gBUILD_Project__c> gbProjects = 
        [
            select projectid__c 
            from PBS_gBUILD_Project__c 
            LIMIT :PBS_gBUILD_Utility.soqlLimit
        ];
                    
        filterExpr = filterExpr.trim();
        boolean numCheck = pattern.matches('^[0-9]+$',filterExpr);
        system.debug('numCheck ----> ' + numCheck);
        string whereClause = '';
        if (filterExpr!='')
        {
            whereClause = string.Format(
                'AND (txtCurrentState__c like {0} or txtLongName__c like {0} or txtRegion__c like {0} or txtProjectManager__c like {0} ', 
                new string[]{'\'%'+string.escapeSingleQuotes(filterExpr)+'%\''});
                
           if (numCheck) {
            whereClause += string.Format(
                'or numProjectNumber__c = {0})', 
                new string[]{string.escapeSingleQuotes(filterExpr)});    
           } else {
           	  whereClause += ')';
           }
                    
        }

        string soql = string.Format(
'            select '+
'                id,'+
'                txtCreatedIn__c,'+
'                txtCurrentState__c,'+
'                txtProjectManager__c,'+
'                txtProgram__c,'+
'                txtProgramArea_FullCode__c, '+
'                txtLongName__c,'+
'                txtRegion__c, '+
'				 numProjectNumber__c'+
'            from PBS_Project__c'+
'            where txtCreatedIn__c in ({3}) {5}'+
'            order by {0} {1}, id'+
'            LIMIT {2}'+
'            OFFSET {4}',
            new string[]{
                sortExpr, 
                sortDir, 
                string.valueOf(pageSize+1),
                PBS_gBUILD_Utility.format(PBS_gBUILD_Utility.allowedBaseProjectCreators, ',', '{0}', true),            
                string.valueOf(pageSize*pageNum),
                whereClause
            });
            
            system.debug('SOQL ---->' +soql);
        PBS_gBUILD_Utility.showDebugMessage(soql);
        List<PBS_Project__c> commonProjects = Database.query(soql);
        allowNext = false;
        if (commonProjects.size()>pageSize)
        {
            allowNext = true;
            commonProjects.remove(pageSize);
        }
        for (PBS_Project__c cp : commonProjects)
        {
            Integer cnt = 0;
            Boolean isGB = false;
            for (PBS_gBUILD_Project__c gbp : gbProjects)
            {
                if (gbp.ProjectId__c==cp.id)
                {
                    ++cnt;
                    isGB = true;
                }
            } 
            epmProjects.add(new EpmProjectWrapper(cp, isGB, cnt));
        }
    }
    
    public PageReference view()
    {
        return new PageReference('/'+createFromEpmId);
    }
    
    public PageReference create()
    {
        PBS_gBUILD_Utility.showDebugMessage('Selected id = '+selectedPbsProjectId);
        createFromEpmId = selectedPbsProjectId;
        
        if (createFromEpmId ==null || createFromEpmId =='')
        {
            PBS_gBUILD_Utility.showWarningMessage('You must select an underlying ePM Project');
            return null;
        }
        
        if (proj.ProjectType__c==null || proj.ProjectType__c=='')
        {
            PBS_gBUILD_Utility.showWarningMessage('You must specify a Project Type');
            return null;
        }
        
        proj.ProjectId__c=createFromEpmId;        
        proj.WorkflowPhaseId__c = PBS_gBUILD_Utility.findInitialWfStateId(
            (proj.ProjectType__c==PBS_gBUILD_Utility.projectTypeNewConstruction || proj.ProjectType__c==PBS_gBUILD_Utility.projectTypeFullModernization) ?
            PBS_gBUILD_Utility.WfStateMachineTypes.Large : 
            PBS_gBUILD_Utility.WfStateMachineTypes.Small
        );
        proj.ModifiedReason__c = 'Project was created';        
        insert proj;
        system.debug('Project ID is---->' + proj.id);
        system.debug('Return URL ID is---->' + PBS_gBUILD_Utility.createLinkProjectBasics(proj.id));
        
        return new PageReference('/apex/PBS_gBUILD_Projects'); //SD
        //return null;
    }

    class EpmProjectWrapper
    {
        public PBS_Project__c rec { get; private set; }
        public Boolean isGB { get; private set; }
        public Boolean renderCreateButton { get; private set;}
        public Integer gbProjectCount { get; private set; }
        public string projectName { get; private set; }
        public EpmProjectWrapper(PBS_Project__c rec, Boolean isGB, Integer gbProjectCount)
        {
            this.rec = rec;
            this.isGB = isGB;
            this.renderCreateButton = !isGB;
            this.gbProjectCount = gbProjectCount;
            this.projectName = PBS_gBUILD_Utility.shorten(rec.txtLongName__c,100);
        }
    }   
}