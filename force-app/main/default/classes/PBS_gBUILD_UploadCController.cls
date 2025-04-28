public with sharing class PBS_gBUILD_UploadCController extends PBS_gBUILD_ComponentBaseController 
{
    public Boolean viewMode { get; set; }
    public Boolean editMode
    {
        get
        {
            return !viewMode;
        }       
    }
    public string actionId { get; set; }
    public String tags { get; set; }
    public String description { get; set; }
    public String epmCatalog { get; set; }
    public string contextualTitle { get; set; }
    public string intro { get; set; }
    public string noAccessContactName { get; set; }
    public string key 
    { 
        get { return this.key_p; }
        set
        {
            if (value!=null && value.contains('_')) PBS_gBUILD_Utility.showErrorMessage(string.format('INVALID PBS_gBUILD_UploadCController key=[{0}]', new string[]{value}));
            this.key_p = value;
        }    
    }
    private string key_p;

    public string readableWaiverKeyPattern { get; set; }
    public string readableWaiverKeyTokens {get;set;}
    public string readableUploadKeys {get;set;}
    public string controlTitle { get; set; }

    public string fileManagerUrl 
    { 
        get
        {
            PBS_gBUILD_ProjectIdBaseController pc = (PBS_gBUILD_ProjectIdBaseController) pageController;
            boolean epm = pc.prolianceAccountName != null;
            PageReference pr = new PageReference('/apex/'+(epm?'PBS_ePM_FileManager':'PBS_gBUILD_FileManager'));
            map<string, string> p = pr.getParameters();
            if (epm)
            {
                if (epmCatalog!=null)
                {
                    p.put(PBS_ePM_FileManagerController.paramNameCatalog, epmCatalog);
                }
                p.put(PBS_ePM_FileManagerController.paramNameOrg, PBS_gBUILD_Utility.epmDefaultOrg);
                p.put(PBS_ePM_FileManagerController.paramNameEpmAccountName, pc.prolianceAccountName);
                p.put(PBS_ePM_FileManagerController.paramNameNoAccessContactName, pc.pmName);
                p.put(PBS_ePM_FileManagerController.paramNameEpmAccountNameForced, '1');
                p.put(PBS_ePM_FileManagerController.paramNameAllowChangeFolder, '0');
                p.put(PBS_ePM_FileManagerController.paramNameFolder, 'gBUILD');
            }
            else            
            {
                p.put(PBS_gBUILD_FileManagerController.paramNameProjectId, pc.projectId);
            }
            if (tags!=null)
            {
                p.put(PBS_ePM_FileManagerController.paramNameTags, tags);        
            }
            if (description!=null)
            {
                p.put(PBS_ePM_FileManagerController.paramNameDescription, description);        
            }
            if (contextualTitle!=null)
            {
                p.put(PBS_ePM_FileManagerController.paramNameContextualTitle, contextualTitle);        
            }
            if (intro!=null)
            {
                p.put(PBS_ePM_FileManagerController.paramNameIntro, intro);        
            }

            string devName = string.Format('P{0}_B{1}_C{2}', new string[]{pc.projectId, pc.pbuildingId, key });
            p.put(PBS_ePM_FileManagerController.paramNameDeveloperName, devName);
            p.put(PBS_ePM_FileManagerController.paramNameDeveloperNameRandomFormat, '{0}_R{1}');
           
            return pr.getUrl();        
        }
    }
    
    private transient List<PBS_gBUILD_Utility.DocInfo> DocInfos_p;
    
    public List<PBS_gBUILD_Utility.DocInfo> DocInfos
    {
        get
        {
            if (DocInfos_p==null)
            {
                PBS_gBUILD_ProjectIdBaseController pc = (PBS_gBUILD_ProjectIdBaseController) pageController;
                List<PBS_gBUILD_Utility.DocInfo> docInfos = new List<PBS_gBUILD_Utility.DocInfo>();
                Set<string> keys = new Set<string>();
                //readableWaiverKeyPattern = 'Mpc[TOKEN]Waivers';
                keys.add(this.key);
                if (readableWaiverKeyPattern != null && readableWaiverKeyTokens != null)
                {
                    for (string token : readableWaiverKeyTokens.split(','))
                    {
                        keys.add(readableWaiverKeyPattern.replace('[TOKEN]', token));                    
                    }
                }
                if (readableUploadKeys != null)
                {
                    for(string token : readableUploadKeys .split(','))
                    {
                        keys.add(token);
                    }
                }
                for (PBS_gBUILD_Utility.DocInfo di : pc.DocInfos)
                {                
                    if (di.pbuildingid==pc.pbuildingid && keys.contains(di.key))
                    {
                        docInfos.add(di);
                    }
                }
                DocInfos_p = docInfos;
            }
            return DocInfos_p;
        }
    }    
    
    public PageReference del()
    {
        Document[] docs = [select id from Document where id=:actionId];
        if (docs.size()>0) delete docs;
        for (integer z=0;z<docinfos.size();++z)
        {
            if (docinfos[z].document!=null && docinfos[z].document.id==actionid)
            {
                docinfos.remove(z);
                break;
            }
        }
        return null;
    }
    
    public integer DocCount
    {
        get { return DocInfos.size(); }
    }
}