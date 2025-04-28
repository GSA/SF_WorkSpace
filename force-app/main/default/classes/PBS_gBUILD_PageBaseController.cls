//http://wiki.developerforce.com/page/Controller_Component_Communication
public with sharing virtual class PBS_gBUILD_PageBaseController 
{
    protected Map<String, PBS_gBUILD_ComponentBaseController> componentControllerMap { get; private set; }
    public boolean isCustomerPortalUser { get; private set; }
    public boolean isViewAllProjectsCustomerPortalAccount { get; private set; }
    public string CustomerPortalContactId { get; private set; }
    public boolean hasPermissionGbAppConfig { get; private set; }
    public boolean hasPermissionGbApplication { get; private set; }
    public boolean hasPermissionGbProjectProposeEcoe { get; private set; }
    public boolean hasPermissionGbProjectCreateGb { get; private set; }
    public boolean hasPermissionGbProjectCreateEpm { get; private set; }
    public boolean hasPermissionGbDesignReview { get; protected set; }
    public boolean hasPermissionGbEcoeApprover { get; private set; }
    public set<string> permissionSetNames { get; private set; }
    
    public Group[] MyGroups
    {
        get
        {
            if (MyGroups_p==null)
            {
                if (isCustomerPortalUser)
                {
                    MyGroups_p = new Group[0];
                }
                else
                {
                    MyGroups_p = PBS_gBUILD_Utility.GetGroupMembership(UserInfo.getUserId(), false);
                }
            }
            return MyGroups_p;
        }
    }
    private Group[] MyGroups_p;
    
    public boolean debugMode
    {
        get { return PBS_gBUILD_Utility.debugMode; }                
    }       
    
    public gBUILD_ApplicationConfig__c AppConfig 
    { 
        get { return PBS_gBUILD_Utility.AppConfig; }
    }
    
    protected virtual void onComponentRegistered(string key, PBS_gBUILD_ComponentBaseController c)
    {}
    
    public void registerComponentController(string key, PBS_gBUILD_ComponentBaseController c)
    {
        if (componentControllerMap==null)
        {
            componentControllerMap = new Map<String, PBS_gBUILD_ComponentBaseController>();
        }
        componentControllerMap.put(key, c);
        onComponentRegistered(key, c);
    }
        
    protected PBS_gBUILD_ComponentBaseController getComponentByKey(string key)
    {
        if (componentControllerMap!=null && componentControllerMap.containsKey(key) )
        {
            return componentControllerMap.get(key);
        }
        return null;
    }
    
    public PBS_gBUILD_PageBaseController getThis() 
    {
        return this;
    }

    protected void bindAppConfig()
    { }

    private transient boolean bindCalled = false;
    protected virtual void bind()
    {
//        PBS_gBUILD_Utility.showDebugMessage(string.format('bind called={0}', new string[]{string.valueOf(bindCalled)}));
        if (bindCalled!=null && bindCalled) return;
        bindCalled = true;
    }
        
    public PBS_gBUILD_PageBaseController()
    {                       
        PBS_gBUILD_Utility.showDebugMessage(string.format(
            'DEBUG MODE: {0}; soqlLimit: {1}', 
            new string[]{PBS_gBUILD_Utility.debugMode?'1':'0', PBS_gBUILD_Utility.soqlLimit.format()}));    

        isCustomerPortalUser = UserInfo.getUserType()=='CspLitePortal' || UserInfo.getUiTheme()=='PortalDefault';
        isViewAllProjectsCustomerPortalAccount = false;
        if (isCustomerPortalUser)
        {        
            try
            {
                User u = [select ContactId, Accountid from user where id=:UserInfo.getUserId()];
                CustomerPortalContactId = u.contactId;
                isViewAllProjectsCustomerPortalAccount = u.AccountId == PBS_gBUILD_Utility.AppConfig.ViewAllProjectsCustomerPortalAccount__c;
            }
            catch (Exception ex){}
        }

        hasPermissionGbAppConfig = false;
        hasPermissionGbApplication = false;
        hasPermissionGbDesignReview = false;
        hasPermissionGbEcoeApprover = false;
        hasPermissionGbProjectProposeEcoe = false;
        hasPermissionGbProjectCreateGb = false;
        hasPermissionGbProjectCreateEpm = false;
        permissionSetNames = new set<string>();

        /*
        http://www.salesforce.com/us/developer/docs/api/index_Left.htm#CSHID=sforce_api_objects_permissionset.htm|StartTopic=Content%2Fsforce_api_objects_permissionset.htm|SkinName=webhelp
        */
        List<string> names = new List<string>();
        PermissionSet[] pss = [
            SELECT Name
            FROM PermissionSet
            WHERE Id in 
            (
                select permissionsetid 
                from PermissionSetAssignment 
                where AssigneeId=:UserInfo.getUserId()
            ) and name in:PBS_gBUILD_Utility.permissionSetNames
        ];
        for (PermissionSet z : pss)
        {
            string name = z.Name;
            permissionSetNames.add(name);
            if (name==PBS_gBUILD_Utility.permissionSetNameAppConfig)
            {
                hasPermissionGbAppConfig = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameApplication)
            {
                hasPermissionGbApplication = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameProjectProposeEcoe)
            {
                hasPermissionGbProjectProposeEcoe = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameProjectCreateGb)
            {
                hasPermissionGbProjectCreateGb = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameProjectCreateEpm)
            {
                hasPermissionGbProjectCreateEpm = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameDesignReviewer)
            {
                hasPermissionGbDesignReview = true;
            }
            else if (name==PBS_gBUILD_Utility.permissionSetNameEcoeApprover)
            {
                hasPermissionGbEcoeApprover = true;
            }
            names.add(name);
        }   
        
        PBS_gBUILD_Utility.showDebugMessage(string.format(
            'UserID: {0}; CustomerPortalUser: {1}; isViewAllProjectsCustomerPortalAccount: {2}; PermissionsSets: {2}',
            new string[]{UserInfo.getUserId(), isCustomerPortalUser?'t':'f', isViewAllProjectsCustomerPortalAccount?'t':'f', PBS_gBUILD_Utility.format(names, ', ')}));
        bindAppConfig();
    }       
    
    protected void ShowErrorMessage(string msg)
    {
        PBS_gBUILD_Utility.ShowErrorMessage(msg);    
    }
    
    protected void ShowDebugMessage(string msg)
    {
        PBS_gBUILD_Utility.ShowDebugMessage(msg);    
    }

    protected void ShowDebugMessage(Exception ex)
    {
        PBS_gBUILD_Utility.ShowDebugMessage(ex);
    }    
}